FROM debian:unstable AS base

LABEL maintainer="C++ Ethereum team"
LABEL repo="https://github.com/ethereum/cpp-build-env"
LABEL version="12"
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
    python3-requests \
    python3-git \
  && rm -rf /var/lib/apt/lists/* \
  && pip3 install --no-cache-dir codecov \
  && apt-key adv --keyserver keyserver.ubuntu.com --no-tty --recv-keys \
    6084F3CF814B57C1CF12EFD515CF4D18AF4F7421 \
    60C317803A41BA51845E371A1E9377A2BA9EF27F \
  && echo 'deb http://deb.debian.org/debian oldstable main' >> /etc/apt/sources.list \
  && echo 'deb http://apt.llvm.org/unstable/ llvm-toolchain-9 main' >> /etc/apt/sources.list \
  && adduser --disabled-password --gecos '' builder && adduser builder sudo && printf 'builder\tALL=NOPASSWD: ALL\n' >> /etc/sudoers

COPY install_default_compiler.sh /usr/bin
USER builder
WORKDIR /home/builder


FROM base AS lint
RUN export DEBIAN_FRONTEND=noninteractive \
  && sudo apt-get -qq update && sudo apt-get install -yq --no-install-recommends \
    clang-format-9 \
    doxygen \
    bumpversion \
    codespell \
  && sudo rm -rf /var/lib/apt/lists/* \
  && sudo ln -s /usr/lib/llvm-9/bin/clang-format /usr/bin/clang-format


FROM base AS gcc-6
RUN install_default_compiler.sh gcc 6

FROM base AS gcc-8
RUN install_default_compiler.sh gcc 8

FROM base AS gcc-9
RUN install_default_compiler.sh gcc 9

FROM base AS clang-3.8
RUN install_default_compiler.sh clang 3.8

FROM base AS clang-9
RUN install_default_compiler.sh clang 9
