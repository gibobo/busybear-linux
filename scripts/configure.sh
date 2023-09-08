#!/bin/bash

set -e

echo "set default configurations"
cp conf/busybox.config  src/busybox/.config
cp conf/linux.config    src/linux/.config

set +e