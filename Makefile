VERSION = 21

targets = base lint gcc-12 gcc-13 gcc-13-multilib clang-16 clang-17

all: ${targets}

${targets}: Dockerfile
	docker build -t ethereum/cpp-build-env:${VERSION}-$@ --target=$@ .


define create_push_target

push/${1}: ${1}
	docker push ethereum/cpp-build-env:${VERSION}-${1}

endef

$(foreach t,${targets},$(eval $(call create_push_target,${t})))

push: $(addprefix push/,${targets})
