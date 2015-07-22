#!/bin/bash

go run src/github.com/vito/gosub/*.go list \
  -a github.com/cloudfoundry-incubator/garden-linux/... \
  -a github.com/cloudfoundry-incubator/garden-linux/container_daemon/initd/... \
  -a github.com/cloudfoundry-incubator/garden-linux/container_daemon/wsh/... \
  -a github.com/cloudfoundry-incubator/garden-linux/containerizer/initc/... \
  -a github.com/cloudfoundry-incubator/garden-linux/containerizer/system/pivotter/... \
  -a github.com/cloudfoundry-incubator/garden-linux/containerizer/wshd/... \
  -a github.com/cloudfoundry-incubator/garden-linux/hook/hook/... \
  -a github.com/cloudfoundry-incubator/garden-linux/integration/helpers/capcheck/... \
  -a github.com/cloudfoundry-incubator/garden-linux/iodaemon/... \
  -a github.com/cloudfoundry-incubator/garden-linux/iodaemon/winsizereporter/... \
  -t github.com/cloudfoundry-incubator/garden-linux/integration/... \
  -t github.com/cloudfoundry-incubator/garden-integration-tests/... \
  -a github.com/vito/gosub/... \
  | xargs go run src/github.com/vito/gosub/*.go sync
