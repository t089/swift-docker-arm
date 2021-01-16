VERSION ?= 5.3.2

# specify name of `arm64` docker context
ARM_CTX = 

# specify name of `amd64` docker context
AMD_CTX = 


REPO = th089/swift

RUN := $(MAKE) build -C ${VERSION} -f ../Makefile

.PHONY: all
all:  bionic focal amazonlinux2 centos8

.PHONY: build
build:
	docker context use ${ARM_CTX}
	docker build . -t ${REPO}:${VERSION}-${DISTRO}-arm64 -f Dockerfile.arm64-${DISTRO}
	docker push ${REPO}:${VERSION}-${DISTRO}-arm64
	docker context use ${AMD_CTX}
	docker pull swift:${VERSION}-${DISTRO}
	docker tag swift:${VERSION}-${DISTRO} ${REPO}:${VERSION}-${DISTRO}-amd64
	docker push ${REPO}:${VERSION}-${DISTRO}-amd64
	docker manifest create --amend ${REPO}:${VERSION}-${DISTRO} ${REPO}:${VERSION}-${DISTRO}-amd64 ${REPO}:${VERSION}-${DISTRO}-arm64
	docker manifest push  ${REPO}:${VERSION}-${DISTRO}

.PHONY: bionic
bionic: export DISTRO = bionic
bionic: export VERSION = 5.3.2
bionic:
	$(RUN)

.PHONY: focal
focal: export DISTRO = focal
focal: export VERSION = 5.3.2
focal:
	$(RUN)


.PHONY: amazonlinux2
amazonlinux2: export DISTRO = amazonlinux2
amazonlinux2: export VERSION = 5.3.2
amazonlinux2:
	$(RUN)

.PHONY: centos8
centos8: export DISTRO = centos8
centos8: export VERSION = 5.3.2
centos8:
	$(RUN)