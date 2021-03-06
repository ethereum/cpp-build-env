#!/bin/sh

version=$2
additional_packages=$3

case "$1" in
    gcc)
        packages="g++-$version"
        cc=gcc
        cxx=g++
        ;;
    clang)
        packages="clang-$version clang-tidy-$version llvm-$version"
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
sudo apt-get install -yq --no-install-recommends $packages $additional_packages
sudo rm -rf /var/lib/apt/lists/*

cd /usr/bin

sudo ln -sfv $cc-$version $cc
sudo ln -sfv $cc-$version cc
sudo ln -sfv $cxx-$version $cxx
sudo ln -sfv $cxx-$version cpp

case "$1" in
  gcc)
    sudo ln -sfv gcov-$version gcov
    ;;
  clang)
    # Expose all clang & LLVM tools without the version suffix.
    sudo ln -sfv ../lib/llvm-$version/bin/llc .
    sudo ln -sfv ../lib/llvm-$version/bin/llvm-* .
    sudo ln -sfv ../lib/llvm-$version/bin/clang-* .
    ;;
esac

cd -
