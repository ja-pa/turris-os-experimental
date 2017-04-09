#!/bin/bash -ex


SDK=OpenWrt-SDK-mvebu_gcc-4.8-linaro_musl-1.1.15_eabi.Linux-x86_64
BUILD_DIR=$(pwd)

prepare_sdk() {
	wget --no-check-certificate https://api.turris.cz/openwrt-repo/omnia/$SDK.tar.bz2 --directory-prefix=/tmp
	mkdir -p $BUILD_DIR/turris/
	tar xjf /tmp/$SDK.tar.bz2 --directory=$BUILD_DIR/turris
	rm -rf /tmp/$SDK.tar.bz2
}

cp_packages() {
	rsync -av --progress $BUILD_DIR/../ $BUILD_DIR/turris/$SDK/package --exclude scripts --exclude=.git
}

build_all() {
	export PATH=$PATH:$BUILD_DIR/turris/$SDK/staging_dir/toolchain-arm_cortex-a9+vfpv3_gcc-4.8-linaro_musl-1.1.15_eabi/bin

	USE_CCACHE=n make CC=arm-openwrt-linux-gcc CXX=arm-openwrt-linux-g++ LD=arm-openwrt-linux-ld V=s -C $BUILD_DIR/turris/$SDK
}

prepare_sdk
cp_packages
build_all
