#!/bin/bash

set -e -x


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RELEASE_DIR="$(dirname "$CURRENT_DIR")"

rm -rf $RELEASE_DIR/btrfs-tools.zip

docker run -v $RELEASE_DIR:/root/release-dir  -w /root/release-dir --privileged --rm ubuntu /root/release-dir/scripts/build-btrfs-tools.sh
