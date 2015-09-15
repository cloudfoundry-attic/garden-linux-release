# Garden Linux Release

A [BOSH](http://docs.cloudfoundry.org/bosh/) release for deploying [Garden Linux](https://github.com/cloudfoundry-incubator/garden-linux).

To deploy Garden Linux to its own virtual machine follow the [Vagrant BOSH instructions](docs/vagrant-bosh.md). Alternatively, to deploy Garden Linux to a Garden container in a virtual machine follow the [BOSH lite instructions](docs/bosh-lite.md).

Note that when deploying to BOSH lite, you **must** have the following properties settings in your manifest:

```
garden:
  mount_btrfs_loopback: false
  disk_quota_enabled: false
```

Either way, when you're done, Garden Linux should be running and you can create containers, run a process in a container, and so on via the [REST API](https://github.com/cloudfoundry-incubator/garden#rest-api).

## Developing

We use [concourse](http://github.com/concourse/concourse) to run our tests. You should first set up concourse (a local vagrant install of concourse will do). If you want to use a remote concourse, set the GARDEN_REMOTE_ATC_URL environment variable, this will be passed as --target to fly if present.

The garden-linux-release package is a bosh release and a go workspace. The included .envrc will set up your GOPATH environment variable for you (if you have [direnv](https://github.com/direnv/direnv) installed and run `direnv allow`). 

You can develop in the submodules (normally src/github.com/cloudfoundry-incubator/garden and src/github.com/cloudfoundry-incubator/garden-linux) and then, when you're ready to bump, run ./scripts/test-and-bump to run all the tests and generate a commit to bump the submodules. You can run all the tests without creating a bump commit with ./scripts/test.

### Example Workflow:

~~~~
direnv allow
git checkout develop # we work on the develop branch, CI commits to master for us
pushd src/github.com/cloudfoundry-incubator/garden-linux
# now make some changes..
popd
./scripts/test # run the tests
./scripts/test-and-bump # run the tests, create a bump commit
~~~~