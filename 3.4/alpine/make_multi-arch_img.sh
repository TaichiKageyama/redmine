#!/bin/bash -ex

IMG=$1
VERSION=3.4.13
export DOCKER_CLI_EXPERIMENTAL=enabled


build_manifest(){
        local img=$1

        rm -rf ~/.docker/manifests/
        docker manifest create ${img} ${img}-amd64 ${img}-arm ${img}-arm64
        docker manifest annotate ${img} ${img}-amd64 --os linux --arch amd64
        docker manifest annotate ${img} ${img}-arm --os linux --arch arm
        docker manifest annotate ${img} ${img}-arm64 --os linux --arch arm64
        docker manifest push -p ${img}
        rm -rf ~/.docker/manifests/
}

make_multi_arch_image(){
        local img_base=$1 img_vers=$2
        local img=${img_base}:${img_vers}

        docker pull ${img}-amd64
        docker pull ${img}-arm
        docker pull ${img}-arm64
        build_manifest ${img}

        docker tag ${img}-amd64 ${img_base}:latest-amd64
        docker tag ${img}-arm ${img_base}:latest-arm
        docker tag ${img}-arm64 ${img_base}:latest-arm64
        docker rmi ${img}-amd64 ${img}-arm  ${img}-arm64

        docker push ${img_base}:latest-amd64
        docker push ${img_base}:latest-arm
        docker push ${img_base}:latest-arm64
        build_manifest ${img_base}:latest
        docker rmi ${img_base}:latest-amd64 ${img_base}:latest-arm ${img_base}:latest-arm64
}

make_multi_arch_image $IMG $VERSION
