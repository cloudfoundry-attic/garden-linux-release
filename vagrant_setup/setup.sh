#!/usr/bin/env bash

# exit if any command fails
set -e

# This script should be executed under user vagrant during provisioning of the machine.

# replace user profile and function definitions with our pre-canned ones
cd ~
rm .profile
ln -s /vagrant_setup/.profile
ln -s /vagrant_setup/.functions

# copy rsa key files to ~/.ssh, but not known_hosts and authorized_keys
mkdir -p /tmp/ssh
mv ~/.ssh/known_hosts /tmp/ssh/ 2>/dev/null || true
mv ~/.ssh/authorized_keys /tmp/ssh 2>/dev/null || true

cp /vagrant_ssh/* ~/.ssh/

rm -f ~/.ssh/known_hosts
rm -f ~/.ssh/authorized_keys

mv /tmp/ssh/* ~/.ssh/ 2>/dev/null || true
