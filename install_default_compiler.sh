#!/bin/sh

version=$2

case "$1" in
    gcc)
        package=g++
        cc=gcc
        cxx=g++
        ;;
    clang)
        package=clang
        cc=clang
        cxx=clang++
        ;;
    *)
        echo "Unsupported compiler: '$1'"
        exit 1
        ;;
esac

package=$package-$version

export DEBIAN_FRONTEND=noninteractive
sudo apt-get -qq update
sudo apt-get install -yq --no-install-recommends $package
sudo rm -rf /var/lib/apt/lists/*
sudo ln -s /usr/bin/$cc-$version /usr/bin/$cc
sudo ln -s /usr/bin/$cc-$version /usr/bin/cc
sudo ln -s /usr/bin/$cxx-$version /usr/bin/$cxx
sudo ln -s /usr/bin/$cxx-$version /usr/bin/cpp
