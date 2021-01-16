# Multi-arch images for Swift

The Dockerfiles in this repo create Swift docker images for `arm64` based on [futurejones/swift-arm64](https://github.com/futurejones/swift-arm64).

The `Makefile` combines the `arm64` image with an official Swift `amd64` image to create a "mutli-arch" image. So a single image can be referenced in a Dockerfile and an image can be built for both `amd64` and `arm64`.

The `Makefile` needs two Docker context names: One for `arm64` and one for `amd64`. If you are building using a M1 mac use `default` for `ARM_CTX` and create a new docker context with a docker daemon that run intel (eg another Mac, Digital Ocean VM, AWS EC2, ... etc): 

`docker context create amd64 --docker host=ssh://my-intel-host`

If you are building from an intel Mac, you need a remote `arm64` instance to build the image. Eg a AWS Graviton2 instance works well.