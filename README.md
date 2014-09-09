# Garden Release

A [BOSH](http://docs.cloudfoundry.org/bosh/) release for deploying Garden
Linux.

To get started with [Vagrant BOSH](https://github.com/cppforlife/vagrant-bosh):

```sh
cd garden-release/

# install the Vagrant BOSH provisioner
vagrant plugin install vagrant-bosh

# install BOSH
gem install bosh_cli

# provision
vagrant up
```


## Development

See the [usage of directories in a bosh
release](https://www.pivotaltracker.com/story/show/78508966).


## Debugging

```sh
cd garden-release/

vagrant ssh

# check logs:
tail -f /var/vcap/sys/log/**/*.log

# check monit:
monit status

# restart garden
monit restart garden

# poke around the deployed jobs
less /var/vcap/jobs/...
```


## Kick the tyres

```sh
# list containers (should be empty)
curl http://127.0.0.1:7777/containers

# create a container
curl -H "Content-Type: application/json" \
  -XPOST http://127.0.0.1:7777/containers \
  -d '{"rootfs":"docker:///busybox"}'

# list containers (should list the handle returned above)
curl http://127.0.0.1:7777/containers

# spawn a process
#
# curl will choke here as the protocol is hijacked, but...it probably worked.
curl -H "Content-Type: application/json" \
  -XPOST http://127.0.0.1:7777/containers/${handle}/processes \
  -d '{"path":"sleep","args":["10"]}'

# from inside the vagrant vm, see 'sleep 10' running:
ps auxf

# hop in the container:
cd /var/vcap/data/garden/depot/${handle}
./bin/wsh
```
