#!/bin/bash
make clean
ARCH=arm
#ARCH=aarch64
if [[ "$ARCH"=="arm" ]];then
	CROSS_COMPILE=arm-linux-gnueabihf-
elif [[ "$ARCH"=="aarch64" ]];then
	CROSS_COMPILE=aarch64-linux-gnu-
fi
echo $CROSS_COMPILE
make -j8 CC="${CROSS_COMPILE}gcc" LD="${CROSS_COMPILE}-ld" HOSTCC=gcc
file ip/ip

PRFX=$(pwd)/output_$ARCH
mkdir -p $PRFX
rm -r $PRFX/*
make PREFIX=$PRFX SBINDIR=$PRFX/sbin ARPDDIR=$PRFX/var/lib/arpd CONFDIR=$PRFX/etc/iproute2 install
tar -czf iproute2_$ARCH.tar.gz -C output_$ARCH .
