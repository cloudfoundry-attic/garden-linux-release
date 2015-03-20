#!/usr/bin/env bash

# exit if any command fails
set -e

# This script should be executed under user vagrant during provisioning of the machine.

# replace user profile and function definitions with our pre-canned ones
cd ~
[ -f .profile ] && rm .profile
ln -s /vagrant_setup/.profile
[ -f .functions ] && rm .functions
ln -s /vagrant_setup/.functions
