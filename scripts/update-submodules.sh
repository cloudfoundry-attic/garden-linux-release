#!/bin/bash

gosub list \
  -a github.com/cloudfoundry-incubator/garden-linux/... \
  -a github.com/cloudfoundry-incubator/garden-linux/containerizer \
  | xargs gosub sync -g ~/go