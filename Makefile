VERSION = 12

targets = base lint gcc-6 gcc-7 gcc-8 gcc-9 clang-3.8 clang-9

all: ${targets}

${targets}: Dockerfile
	docker build -t ethereum/cpp-build-env:${VERSION}-$@ --target=$@ .
