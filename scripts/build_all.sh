#!/bin/bash -ex

SDK=OpenWrt-SDK-mvebu_gcc-4.8-linaro_musl-1.1.15_eabi.Linux-x86_64
BUILD_DIR=$(pwd)

prepare_sdk() {
	wget --no-check-certificate https://api.turris.cz/openwrt-repo/omnia/$SDK.tar.bz2 --directory-prefix=/tmp
	mkdir -p $BUILD_DIR/turris/
	tar xjf /tmp/$SDK.tar.bz2 --directory=$BUILD_DIR/turris
	rm -rf /tmp/$SDK.tar.bz2
}

clean_sdk() {
	find $BUILD_DIR/turris/$SDK/package -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} \;
}

clean_bin() {
	rm -rf $BUILD_DIR/turris/$SDK/bin/mvebu-musl/packages/base/*
}

cp_packages() {
	rsync -av --progress $BUILD_DIR/../ $BUILD_DIR/turris/$SDK/package --exclude scripts --exclude=.git --exclude-from=$BUILD_DIR/exclude_from_build.txt
}

cp_package() {
	package_path="$1"
	rsync -av --progress $package_path $BUILD_DIR/turris/$SDK/package
}


build_all() {
	export PATH=$PATH:$BUILD_DIR/turris/$SDK/staging_dir/toolchain-arm_cortex-a9+vfpv3_gcc-4.8-linaro_musl-1.1.15_eabi/bin
	USE_CCACHE=n make CC=arm-openwrt-linux-gcc CXX=arm-openwrt-linux-g++ LD=arm-openwrt-linux-ld -C $BUILD_DIR/turris/$SDK
}

cp_binaries() {
	mkdir $BUILD_DIR/bin
	rsync -av --progress $BUILD_DIR/turris/$SDK/bin/mvebu-musl/packages/base/ $BUILD_DIR/bin
}

case $1 in
--build-package)
	echo "Building package $2:"
	package_path=$BUILD_DIR/../$2
	if [ -d "$package_path" ] && [ ! -z "$2" ]; then
		echo "Building package $2"
		clean_sdk
		clean_bin
		cp_package "$package_path"
		build_all
		cp_binaries
	else
		echo "Error package $2 not found"
	fi
	;;
--help)
	echo "Help"
	;;
*)
	echo "Build all..."
	prepare_sdk
	cp_packages
	build_all
	cp_binaries
	;;
esac
