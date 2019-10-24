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

cd /usr/bin

sudo ln -s $cc-$version $cc
sudo ln -s $cc-$version cc
sudo ln -s $cxx-$version $cxx
sudo ln -s $cxx-$version cpp

case "$1" in
  gcc)
    sudo ln -s gcov-$version gcov
    ;;
  clang)
    # Expose all LLVM tools without the version suffix.
    sudo ln -s ../lib/llvm-$version/bin/llc .
    sudo ln -s ../lib/llvm-$version/bin/llvm-* .
    ;;
esac

cd -
