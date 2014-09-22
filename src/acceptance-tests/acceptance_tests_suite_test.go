package acceptance_test

import (
	"os"
	"testing"

	"github.com/cloudfoundry-incubator/garden/api"
	"github.com/cloudfoundry-incubator/garden/client"
	"github.com/cloudfoundry-incubator/garden/client/connection"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var wardenClient api.Client

var _ = BeforeSuite(func() {
	wardenNetwork := os.Getenv("WARDEN_NETWORK")
	Ω(wardenNetwork).ShouldNot(BeEmpty(), "$WARDEN_NETWORK must be set")

	wardenAddr := os.Getenv("WARDEN_ADDR")
	Ω(wardenAddr).ShouldNot(BeEmpty(), "$WARDEN_ADDR must be set")

	wardenClient = client.New(connection.New(wardenNetwork, wardenAddr))

	err := wardenClient.Ping()
	Ω(err).ShouldNot(HaveOccurred(), "Warden is not pingable.")
})

func TestAcceptance(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "AcceptanceTests Suite")
}
