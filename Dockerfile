FROM debian:unstable AS base

LABEL maintainer="C++ Ethereum team"
LABEL repo="https://github.com/ethereum/cpp-build-env"
LABEL version="22"
LABEL description="Build environment for C++ Ethereum projects"

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get -qq update && apt-get install -yq --no-install-recommends \
    curl \
    dirmngr \
    gnupg2 \
    sudo \
    # Build tools
    git \
    ssh-client \
    cmake \
    make \
    ninja-build \
    # Python dependencies
    python3-setuptools \
    python3-wheel \
    python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && apt-key adv --keyserver keyserver.ubuntu.com --no-tty --recv-keys \
    6084F3CF814B57C1CF12EFD515CF4D18AF4F7421 \
    27034E7FDB850E0BBC2C62FF806BB28AED779869 \
  && adduser --disabled-password --gecos '' builder && adduser builder sudo && printf 'builder\tALL=NOPASSWD: ALL\n' >> /etc/sudoers \
  && rm /tmp/* -rf

COPY install_default_compiler.sh /usr/bin
USER builder
WORKDIR /home/builder


FROM base AS lint
RUN export DEBIAN_FRONTEND=noninteractive \
  && sudo apt-get -qq update && sudo apt-get install -yq --no-install-recommends \
    clang-format-18 \
    bumpversion \
    codespell \
    shellcheck \
  && sudo rm -rf /var/lib/apt/lists/* \
  && sudo ln -s /usr/bin/clang-format-18 /usr/bin/clang-format

FROM base AS gcc-12
RUN install_default_compiler.sh gcc 12

FROM base AS gcc-13
RUN install_default_compiler.sh gcc 13

FROM base AS gcc-14
RUN install_default_compiler.sh gcc 14 'valgrind qemu-user-static gcovr'

FROM gcc-14 AS gcc-14-multilib
RUN sudo apt-get -qq update && sudo apt-get install -yq g++-14-multilib && sudo rm -rf /var/lib/apt/lists/*

FROM base AS clang-17
RUN install_default_compiler.sh clang 17 'libclang-rt-17-dev'

FROM lint AS clang-18
RUN install_default_compiler.sh clang 18 'libclang-rt-18-dev libc++-18-dev libc++abi-18-dev gcovr'
