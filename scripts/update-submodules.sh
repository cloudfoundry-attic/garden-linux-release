#!/bin/bash

gosub list \
  -a github.com/cloudfoundry-incubator/garden-linux/... \
  | xargs gosub sync
