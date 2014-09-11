# Vagrant BOSH

Vagrant BOSH is used to deploy Garden Linux to its own virtual machine, i.e. not inside a container.

To get started with [Vagrant BOSH](https://github.com/cppforlife/vagrant-bosh):

```sh
cd garden-release/

# Obtain submodules
git submodule update --init --recursive

# install the Vagrant BOSH provisioner
vagrant plugin install vagrant-bosh

# install BOSH
gem install bosh_cli

# provision
vagrant up
```


## Development

See the [usage of directories in a BOSH
release](https://www.pivotaltracker.com/story/show/78508966).


## Debugging

```sh
cd garden-linux-release/

vagrant ssh

# escalate to root
sudo su -

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

Use the [REST API](https://github.com/cloudfoundry-incubator/garden#rest-api) against endpoint `http://127.0.0.1:7777` to create a container, then:
```
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

## Update the release

Once the VM is up, modify it by issuing:
```
vagrant provision
```

## Create another blob
See the bosh documentation for [adding blobs](http://docs.cloudfoundry.org/bosh/create-release.html#blobs) including setting up `config/private.yml` with appropriate S3 keys, and then issue:
```
bosh upload blobs
```

## Destroy the release
```
vagrant destroy
```

# BOSH Lite

To get started with [BOSH lite](https://github.com/cloudfoundry/bosh-lite), follow the
instructions to [Prepare the Environment](https://github.com/cloudfoundry/bosh-lite#install-and-boot-a-virtual-machine)
and [Install and Boot a Virtual Machine](https://github.com/cloudfoundry/bosh-lite#install-and-boot-a-virtual-machine), then:

```sh
cd garden-linux-release/

# Obtain submodules
git submodule update --init --recursive

# create and upload a BOSH release
# (if there are changes in the git repository, specify --force on create)
bosh -n create release
bosh -n upload release
```

Then follow the instructions for downloading a stemcell in [Manually Deploying Cloud Foundry](https://github.com/cloudfoundry/bosh-lite/blob/master/docs/deploy-cf.md#manual-deploy), choosing a stemcell with `warden-boshlite-ubuntu-trusty` in the name:
```
bosh public stemcells
bosh download public stemcell <stemcell_name>
```

Upload the downloaded stemcell to the BOSH lite instance:
```
bosh upload stemcell <stemcell_file_name>
```

Then deploy Garden Linux to BOSH lite:
```
bosh deployment manifests/bosh-lite.yml
bosh deploy
```

Check the state of the deployment:
```
bosh vms
bosh ssh <Garden job/index>
```
Make a note of the IP address of the Garden job.

Then, assuming you ran `bin/add-route` as part of setting up BOSH Lite, operate on Garden Linux from outside the VM:
```
url http://<IP address of Garden job>:7777/containers
```

or from inside the VM:
```
sudo su -
curl http://127.0.0.1:7777/containers
```
and so on as per the Vagrant BOSH insructions above.