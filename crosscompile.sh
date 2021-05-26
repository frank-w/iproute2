#!/bin/bash
make clean
rm config.mk
ARCH=arm
ARCH=aarch64

if [[ "$ARCH" == "arm" ]];then
	CROSS_COMPILE=arm-linux-gnueabihf-
elif [[ "$ARCH" == "aarch64" ]];then
	CROSS_COMPILE=aarch64-linux-gnu-
fi
echo $ARCH $CROSS_COMPILE
make CC="${CROSS_COMPILE}gcc" LD="${CROSS_COMPILE}-ld" HOSTCC=gcc config.mk
sed -i 's/^\(.*mnl\)/#\1/i' config.mk
sed -i 's/^\(.*selinux\)/#\1/i' config.mk

make -j8 CC="${CROSS_COMPILE}gcc" LD="${CROSS_COMPILE}-ld" HOSTCC=gcc
#LDFLAGS=-static
#-L/media/data_nvme/git/nftables-bpi/libmnl/install/lib"

if [[ $? -eq 0 ]];then
file ip/ip

PRFX=$(pwd)/output_$ARCH
mkdir -p $PRFX
rm -r $PRFX/*
#make PREFIX=$PRFX SBINDIR=$PRFX/usr/local/sbin ARPDDIR=$PRFX/var/lib/arpd CONFDIR=$PRFX/etc/iproute2 install
make DESTDIR=$PRFX PREFIX=/usr/local SBINDIR=/usr/local/sbin ARPDDIR=/var/lib/arpd CONFDIR=/etc/iproute2 install
tar -czf iproute2_$ARCH.tar.gz -C output_$ARCH .
fi
