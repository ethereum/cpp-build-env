VERSION = 19

targets = base lint gcc-11 gcc-12 gcc-12-multilib clang-13 clang-14 clang-15

all: ${targets}

${targets}: Dockerfile
	docker build -t ethereum/cpp-build-env:${VERSION}-$@ --target=$@ .


define create_push_target

push/${1}: ${1}
	docker push ethereum/cpp-build-env:${VERSION}-${1}

endef

$(foreach t,${targets},$(eval $(call create_push_target,${t})))

push: $(addprefix push/,${targets})
