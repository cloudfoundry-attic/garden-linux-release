package main

import (
	"fmt"
	"log"
	"math/rand"
	"os"
	"time"

	"github.com/cloudfoundry-incubator/garden"
	"github.com/cloudfoundry-incubator/garden/client"
	"github.com/cloudfoundry-incubator/garden/client/connection"
)

func main() {
	var (
		rootfs       string        = "docker:///busybox"
		gardenHost   string        = os.Getenv("GARDEN_ADDRESS")
		gardenClient garden.Client = client.New(connection.New("tcp", gardenHost))
	)

	rand.Seed(time.Now().UnixNano())
	maxCreateCnt := 75

	fmt.Println("Max create loop count", maxCreateCnt)
	handles := make(chan string, maxCreateCnt)

	for i := 0; i < maxCreateCnt; i++ {
		go func(containers chan string) {
			WaitRandomly()
			container, err := gardenClient.Create(garden.ContainerSpec{
				RootFSPath: rootfs,
			})

			if err != nil {
				log.Fatal(err)
			}

			fmt.Printf("Container created %s\n", container.Handle())
			containers <- container.Handle()
		}(handles)
	}

	done := make(chan bool)

loop:
	for {
		select {
		case containerHandle := <-handles:
			go func(handle string) {
				WaitRandomly()
				fmt.Printf("Destroying container handle %s\n", handle)
				err := gardenClient.Destroy(handle)

				if err != nil {
					log.Fatal(err)
				}

				done <- true
			}(containerHandle)
		case <-done:
			maxCreateCnt--
			if maxCreateCnt == 0 {
				fmt.Println("Operation completed")
				break loop
			}
		}
	}
}

func WaitRandomly() {
	rand.Seed(time.Now().UnixNano())
	timeout := time.Duration(rand.Intn(500))
	fmt.Printf("Waiting for %v\n", timeout)
	time.Sleep(timeout * time.Millisecond)
}
