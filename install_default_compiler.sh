#!/bin/sh

version=$2

case "$1" in
    gcc)
        packages="g++-$version"
        cc=gcc
        cxx=g++
        ;;
    clang)
        packages="clang-$version llvm-$version"
        cc=clang
        cxx=clang++
        ;;
    *)
        echo "Unsupported compiler: '$1'"
        exit 1
        ;;
esac

export DEBIAN_FRONTEND=noninteractive
sudo apt-get -qq update
sudo apt-get install -yq --no-install-recommends $packages
sudo rm -rf /var/lib/apt/lists/*

sudo ln -s /usr/bin/$cc-$version /usr/bin/$cc
sudo ln -s /usr/bin/$cc-$version /usr/bin/cc
sudo ln -s /usr/bin/$cxx-$version /usr/bin/$cxx
sudo ln -s /usr/bin/$cxx-$version /usr/bin/cpp

# Expose all LLVM tools without the version suffix.
if [ "$1" = clang ]; then
  cd /usr/bin
  sudo ln -s ../lib/llvm-$version/bin/llc .
  sudo ln -s ../lib/llvm-$version/bin/llvm-* .
fi
