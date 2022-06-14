VERSION = 18

targets = base lint gcc-9 gcc-10 gcc-11 gcc-12 gcc-12-multilib clang-11 clang-12 clang-13 clang-14

all: ${targets}

${targets}: Dockerfile
	docker build -t ethereum/cpp-build-env:${VERSION}-$@ --target=$@ .


define create_push_target

push/${1}: ${1}
	docker push ethereum/cpp-build-env:${VERSION}-${1}

endef

$(foreach t,${targets},$(eval $(call create_push_target,${t})))

push: $(addprefix push/,${targets})
