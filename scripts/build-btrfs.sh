#!/bin/bash
set -e -x

# this script runs inside a ubuntu docker container
# to build the btrfs-tools from source present in garden linux release

# use run-btrfs-build-in-docker to run this script inside a docker container

REPO_URL=https://github.com/kdave/btrfs-progs.git
TAG=$1


apt-get update
apt-get install -y asciidoc xmlto --no-install-recommends
apt-get install -y pkg-config autoconf
apt-get install -y uuid-dev libattr1-dev zlib1g-dev libacl1-dev e2fslibs-dev libblkid-dev liblzo2-dev
apt-get install -y git-core make

mkdir -p /tmp/output
mkdir -p /tmp/input

pushd /tmp/input
	git clone $REPO_URL
	cd btrfs-progs
	git checkout $TAG
	./autogen.sh
	./configure --prefix=/tmp/output
	make
	make install
popd

pushd /tmp/output
	rm -rf share
	rm -rf /root/release-dir/btrfs-progs-$TAG.tar.gz
	tar -czf /root/release-dir/btrfs-progs-$TAG.tar.gz ./*
popd

rm -rf /tmp/output
rm -rf /tmp/input
