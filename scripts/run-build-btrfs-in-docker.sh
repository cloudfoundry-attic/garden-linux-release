#!/bin/bash

set -e -x


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
RELEASE_DIR="$(dirname "$CURRENT_DIR")"

TAG=$1

if [ -z "$TAG" ]; then
	echo "Please provide a tag"
	exit 1
fi

docker run -v $RELEASE_DIR:/root/release-dir \
					 -w /root/release-dir \
					 -it \
					 --privileged \
					 --rm \
					 ubuntu \
					 /root/release-dir/scripts/build-btrfs.sh $TAG

echo "Build exported to $RELEASE_DIR/btrfs-progs-$TAG.tar.gz"
