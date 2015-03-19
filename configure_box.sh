#!/usr/bin/env bash

# install system updates and latest git and mercurial
apt-get update
apt-get install -y git
apt-get install -y mercurial

# install go version 1.3.1
curl -s -o /tmp/go.tgz https://storage.googleapis.com/golang/go1.3.1.linux-amd64.tar.gz
tar -C /usr/local -xzf /tmp/go.tgz
rm /tmp/go.tgz

# run setup script under vagrant user
su -c "cd /vagrant_setup && ./setup.sh" vagrant
