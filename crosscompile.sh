#!/bin/bash
make clean
CROSS_COMPILE=arm-linux-gnueabihf-
#CROSS_COMPILE=aarch64-linux-gnu-
make -j8 CC="${CROSS_COMPILE}gcc" LD="${CROSS_COMPILE}-ld" HOSTCC=gcc
file ip/ip
