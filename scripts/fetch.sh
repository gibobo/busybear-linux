#!/bin/bash

set -e

. conf/busybear.config

#
# test environment
#
for var in BUSYBOX_VERSION DROPBEAR_VERSION LINUX_KERNEL_VERSION; do
    if [ -z "${!var}" ]; then
        echo "${!var} not set" && exit 1
    fi
done

#
# download busybox, dropbear and linux
#
test -d archives || mkdir archives
test -f archives/busybox-${BUSYBOX_VERSION}.tar.bz2 || \
    curl -L -o archives/busybox-${BUSYBOX_VERSION}.tar.bz2 \
        https://busybox.net/downloads/busybox-${BUSYBOX_VERSION}.tar.bz2
test -f archives/dropbear-${DROPBEAR_VERSION}.tar.bz2 || \
    curl -L -o archives/dropbear-${DROPBEAR_VERSION}.tar.bz2 \
        https://matt.ucc.asn.au/dropbear/releases/dropbear-${DROPBEAR_VERSION}.tar.bz2
test -f archives/linux-${LINUX_KERNEL_VERSION}.tar.gz || \
    curl -L -o archives/linux-${LINUX_KERNEL_VERSION}.tar.gz \
        https://git.kernel.org/torvalds/t/linux-${LINUX_KERNEL_VERSION}.tar.gz

#
# extract busybox, dropbear and linux
#
test -d src/busybox || \
    tar -C src/busybox -xjf archives/busybox-${BUSYBOX_VERSION}.tar.bz2
test -d src/dropbear || \
    tar -C src/dropbear -xjf archives/dropbear-${DROPBEAR_VERSION}.tar.bz2
test -d src/linux || \
    tar -C src/linux -xzf archives/linux-${LINUX_KERNEL_VERSION}.tar.gz
