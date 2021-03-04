VERSION ?= 5.3.3

# specify name of `arm64` docker context
ARM_CTX = default

# specify name of `amd64` docker context
AMD_CTX = amd64


REPO = th089/swift

RUN = $(MAKE) build -C ${VERSION} -f ../Makefile VERSION=${VERSION}

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
bionic: DISTRO = bionic
bionic:
	$(RUN) DISTRO=bionic
	docker manifest create --amend ${REPO}:bionic ${REPO}:${VERSION}-bionic-amd64 ${REPO}:${VERSION}-bionic-arm64
	docker manifest push ${REPO}:bionic

.PHONY: focal
focal:
	$(RUN) DISTRO=focal


.PHONY: amazonlinux2
amazonlinux2:
	$(RUN) DISTRO=amazonlinux2

.PHONY: all
all:  bionic focal amazonlinux2 centos8