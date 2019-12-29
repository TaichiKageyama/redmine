#!/bin/bash -ex

IMG=$1
VERSION=3.4.13
ARCH=`arch`

case $ARCH in
 "x86_64"  ) ARCH=amd64;;
 "armv7l"  ) ARCH=arm;;
 "aarch64" ) ARCH=arm64;;
esac

build_img()
{
        docker build -t ${IMG}:${VERSION}-${ARCH} .
        docker push ${IMG}:${VERSION}-${ARCH}
}

build_img
