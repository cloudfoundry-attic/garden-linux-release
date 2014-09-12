package acceptance_test

import (
	"bytes"
	"time"

	"github.com/cloudfoundry-incubator/garden/warden"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
)

var _ = Describe("With a container", func() {
	var container warden.Container

	BeforeEach(func() {
		var err error

		container, err = wardenClient.Create(warden.ContainerSpec{})
		Ω(err).ShouldNot(HaveOccurred())
	})

	AfterEach(func() {
		err := wardenClient.Destroy(container.Handle())
		Ω(err).ShouldNot(HaveOccurred())
	})

	Describe("running a process", func() {
		It("streams output back and reports the exit status", func() {
			stdout := gbytes.NewBuffer()
			stderr := gbytes.NewBuffer()

			process, err := container.Run(warden.ProcessSpec{
				Path: "sh",
				Args: []string{"-c", "sleep 0.5; echo $FIRST; sleep 0.5; echo $SECOND >&2; sleep 0.5; exit 42"},
				Env:  []string{"FIRST=hello", "SECOND=goodbye"},
			}, warden.ProcessIO{
				Stdout: stdout,
				Stderr: stderr,
			})
			Ω(err).ShouldNot(HaveOccurred())

			Eventually(stdout).Should(gbytes.Say("hello\n"))
			Eventually(stderr).Should(gbytes.Say("goodbye\n"))
			Ω(process.Wait()).Should(Equal(42))
		})

		It("streams input to the process's stdin", func() {
			stdout := gbytes.NewBuffer()

			process, err := container.Run(warden.ProcessSpec{
				Path: "sh",
				Args: []string{"-c", "cat <&0"},
			}, warden.ProcessIO{
				Stdin:  bytes.NewBufferString("hello\nworld"),
				Stdout: stdout,
			})
			Ω(err).ShouldNot(HaveOccurred())

			Eventually(stdout).Should(gbytes.Say("hello\nworld"))
			Ω(process.Wait()).Should(Equal(0))
		})

		Context("and then attaching to it", func() {
			It("streams output and the exit status to the attached request", func(done Done) {
				stdout1 := gbytes.NewBuffer()
				stdout2 := gbytes.NewBuffer()

				process, err := container.Run(warden.ProcessSpec{
					Path: "sh",
					Args: []string{"-c", "sleep 2; echo hello; sleep 0.5; echo goodbye; sleep 0.5; exit 42"},
				}, warden.ProcessIO{
					Stdout: stdout1,
				})
				Ω(err).ShouldNot(HaveOccurred())

				attached, err := container.Attach(process.ID(), warden.ProcessIO{
					Stdout: stdout2,
				})
				Ω(err).ShouldNot(HaveOccurred())

				time.Sleep(2 * time.Second)

				Eventually(stdout1).Should(gbytes.Say("hello\n"))
				Eventually(stdout1).Should(gbytes.Say("goodbye\n"))

				Eventually(stdout2).Should(gbytes.Say("hello\n"))
				Eventually(stdout2).Should(gbytes.Say("goodbye\n"))

				Ω(process.Wait()).Should(Equal(42))
				Ω(attached.Wait()).Should(Equal(42))

				close(done)
			}, 10.0)
		})

		Context("and then sending a Stop request", func() {
			It("terminates all running processes", func() {
				stdout := gbytes.NewBuffer()

				process, err := container.Run(warden.ProcessSpec{
					Path: "sh",
					Args: []string{
						"-c",
						`
            trap 'exit 42' SIGTERM

            # sync with test, and allow trap to fire when not sleeping
            while true; do
              echo waiting
              sleep 0.5
            done
            `,
					},
				}, warden.ProcessIO{
					Stdout: stdout,
				})
				Ω(err).ShouldNot(HaveOccurred())

				Eventually(stdout, 30).Should(gbytes.Say("waiting"))

				err = container.Stop(false)
				Ω(err).ShouldNot(HaveOccurred())

				Ω(process.Wait()).Should(Equal(42))
			})
		})
	})
})
