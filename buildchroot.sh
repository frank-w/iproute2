#!/bin/bash
sudo apt-get install qemu-user-static debootstrap binfmt-support

set -x

distro=buster
arch=armhf
#for bpi-r64 use
#arch=arm64

targetdir=$(pwd)/debian_${distro}_${arch}
#if false; then
mkdir $targetdir
sudo debootstrap --arch=$arch --foreign $distro $targetdir
case "$arch" in
"armhf")
	sudo cp /usr/bin/qemu-arm-static $targetdir/usr/bin/
	;;
"arm64")
#for r64 use
	sudo cp /usr/bin/qemu-aarch64-static $targetdir/usr/bin/
	;;
"amd64")
	;;
*) echo "unsupported arch $arch";;
esac
sudo cp /etc/resolv.conf $targetdir/etc
LANG=C
sudo chroot $targetdir /debootstrap/debootstrap --second-stage
#fi
langcode=de
sudo chroot $targetdir tee "/etc/apt/sources.list" > /dev/null <<EOF
deb http://ftp.$langcode.debian.org/debian $distro main contrib non-free
deb-src http://ftp.$langcode.debian.org/debian $distro main contrib non-free
deb http://ftp.$langcode.debian.org/debian $distro-updates main contrib non-free
deb-src http://ftp.$langcode.debian.org/debian $distro-updates main contrib non-free
deb http://security.debian.org/debian-security $distro/updates main contrib non-free
deb-src http://security.debian.org/debian-security $distro/updates main contrib non-free
EOF
