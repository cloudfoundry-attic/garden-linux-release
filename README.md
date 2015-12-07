# Garden Linux Release

A [BOSH](http://docs.cloudfoundry.org/bosh/) release for deploying [Garden Linux](https://github.com/cloudfoundry-incubator/garden-linux).

To play with it, deploy to BOSH Lite in the usual way:

```
git clone --recursive https://github.com/cloudfoundry-incubator/garden-linux-release
cd garden-linux-release
bosh create release
bosh upload release
bosh deployment manifests/bosh-lite.yml
bosh deploy
```

When you're done, Garden Linux should be running and you can create containers, run a process in a container, and so on via the [garden client](https://github.com/cloudfoundry-incubator/garden).

To update to a new version:

```
git pull
git submodule update --init --recursive
bosh create release
bosh upload release
bosh deployment manifests/bosh-lite.yml
bosh deploy
```

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
