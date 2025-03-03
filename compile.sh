#!/bin/bash
# Copyright cc 2023 sirnewbies

git submodule init

git submodule update --remote

# setup color
red='\033[0;31m'
green='\e[0;32m'
white='\033[0m'
yellow='\033[0;33m'

# setup dir
WORK_DIR=$(pwd)
KERN_IMG="${WORK_DIR}/out/arch/arm64/boot/Image-gz.dtb"
KERN_IMG2="${WORK_DIR}/out/arch/arm64/boot/Image.gz"

function clean() {
    echo -e "\n"
    echo -e "$red << cleaning up >> \n$white"
    echo -e "\n"
    rm -rf out
}

export KBUILD_BUILD_HOST=Play
export KBUILD_BUILD_USER="Pragmatic"

function build_kernel() {
    export PATH="/workspace/kernel_realme_sdm710/weebx/bin:$PATH"
    make -j$(nproc --all) O=out ARCH=arm64 nian_defconfig
    make -j$(nproc --all) ARCH=arm64 O=out \
                          LLVM=1 \
                          CC=clang \
                          CLANG_TRIPLE=aarch64-linux-gnu- \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi-
    if [ -e "$KERN_IMG" ] || [ -e "$KERN_IMG2" ]; then
        echo -e "\n"
        echo -e "$green << compile kernel success! >> \n$white"
        echo -e "\n"
    else
        echo -e "\n"
        echo -e "$red << compile kernel failed! >> \n$white"
        echo -e "\n"
    fi
}

# execute
clean
build_kernel
