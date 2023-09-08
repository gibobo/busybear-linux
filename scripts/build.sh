#!/bin/bash

set -e

. conf/busybear.config

#
# test environment
#
for var in ARCH ABI CROSS_COMPILE BUSYBOX_VERSION \
    DROPBEAR_VERSION LINUX_KERNEL_VERSION; do
    if [ -z "${!var}" ]; then
        echo "${!var} not set" && exit 1
    fi
done

#
# find executables
#
for prog in ${CROSS_COMPILE}gcc sudo nproc curl openssl rsync; do
    if [ -z $(which ${prog}) ]; then
        echo "error: ${prog} not found in PATH" && exit 1
    fi
done

#
# download and extract busybox, dropbear and linux
#
# ./scripts/fetch.sh
# git submodule update --init --recursive

#
# set default configurations
#
./scripts/configure.sh

#
# build busybox, dropbear, linux and bbl
#
./scripts/compile.sh

#
# create filesystem image
#
sudo env PATH="${PATH}" UID=$(id -u) GID=$(id -g) \
./scripts/image.sh
