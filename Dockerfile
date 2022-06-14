FROM debian:unstable AS base

LABEL maintainer="C++ Ethereum team"
LABEL repo="https://github.com/ethereum/cpp-build-env"
LABEL version="18"
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
  && pip3 install --no-cache-dir codecov \
  && apt-key adv --keyserver keyserver.ubuntu.com --no-tty --recv-keys \
    6084F3CF814B57C1CF12EFD515CF4D18AF4F7421 \
    60C317803A41BA51845E371A1E9377A2BA9EF27F \
  && adduser --disabled-password --gecos '' builder && adduser builder sudo && printf 'builder\tALL=NOPASSWD: ALL\n' >> /etc/sudoers \
  && rm /tmp/* -rf

COPY install_default_compiler.sh /usr/bin
USER builder
WORKDIR /home/builder


FROM base AS lint
RUN export DEBIAN_FRONTEND=noninteractive \
  && sudo apt-get -qq update && sudo apt-get install -yq --no-install-recommends \
    clang-format-14 \
    bumpversion \
    codespell \
    shellcheck \
  && sudo rm -rf /var/lib/apt/lists/* \
  && sudo ln -s /usr/bin/clang-format-14 /usr/bin/clang-format


FROM base AS gcc-9
RUN install_default_compiler.sh gcc 9

FROM base AS gcc-10
RUN install_default_compiler.sh gcc 10

FROM base AS gcc-11
RUN install_default_compiler.sh gcc 11

FROM base AS gcc-12
RUN install_default_compiler.sh gcc 12 lcov

FROM gcc-12 AS gcc-12-multilib
RUN sudo apt-get -qq update && sudo apt-get install -yq g++-12-multilib && sudo rm -rf /var/lib/apt/lists/*

FROM base AS clang-11
RUN install_default_compiler.sh clang 11

FROM base AS clang-12
RUN install_default_compiler.sh clang 12

FROM base AS clang-13
RUN install_default_compiler.sh clang 13

FROM lint AS clang-14
RUN install_default_compiler.sh clang 14 'libc++-14-dev libc++abi-14-dev lcov'
