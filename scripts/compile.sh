#!/bin/bash

set -e

. conf/busybear.config

#
# test environment
#
for var in CROSS_COMPILE; do
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

[ ! -d build ] && mkdir build -p


#
# build busybox, dropbear and linux
#
export MAKEFLAGS=-j$(nproc)

echo "# build busybox"
test -x src/busybox/busybox || (
    cd src/busybox
    make clean
    make ARCH=riscv CROSS_COMPILE=${CROSS_COMPILE} oldconfig
    make ARCH=riscv CROSS_COMPILE=${CROSS_COMPILE} -j$(nproc)
)

echo "# build dropbear"
test -d build/dropbear  || mkdir build/dropbear/ -p
test -x build/dropbear/dropbear || (
    cd build/dropbear
    ../../src/dropbear/configure \
        --host=${CROSS_COMPILE%-} \
        --disable-zlib
    make clean
    make -j$(nproc)
)

echo "# build linux"
test -x src/linux/vmlinux || (
    cd src/linux
    make ARCH=riscv olddefconfig
    make -j$(nproc) ARCH=riscv CROSS_COMPILE=${CROSS_COMPILE} vmlinux CONFIG_DEBUG_INFO=y
    cp vmlinux ../../build/
)

echo "# build bbl"

#
# build bbl
#
test -d build/riscv-pk || mkdir build/riscv-pk
test -x build/riscv-pk/bbl || (
    cd build/riscv-pk
    ../../src/riscv-pk/configure \
        --enable-logo \
        --host=${CROSS_COMPILE%-} \
        --with-payload=../vmlinux
    make -j$(nproc)
    cp bbl ../
)

echo "!! build Compile !!"