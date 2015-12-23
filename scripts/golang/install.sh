#!/bin/sh

# Inspired by https://github.com/docker-library/golang/blob/master/1.5/alpine/Dockerfile

set -ex

export GOLANG_VERSION=1.5.2
export GOLANG_SRC_SHA256=f3ddd624c00461641ce3d3a8d8e3c622392384ca7699e901b370a4eac5987a74

export GOLANG_BOOTSTRAP_VERSION=1.4.3
export GOLANG_BOOTSTRAP_SHA256=9947fc705b0b841b5938c48b22dc33e9647ec0752bae66e50278df4f23f64959

prefix=/usr/local
bootstrap_prefix=${prefix}/bootstrap
goroot_bootstrap=${bootstrap_prefix}/go
go_archive=/golang.tar.gz
go_root=${prefix}/go

golang_url() {
	printf "https://golang.org/dl/go%s.src.tar.gz" "$1"
}

# Install golang build dependencies.
apk add --update-cache --virtual golang-dependencies bash ca-certificates gcc musl-dev openssl tar

# Ensure bootstrap dir present.
mkdir -p "${bootstrap_prefix}"

# Download bootstrap package.
wget -q "$(golang_url ${GOLANG_BOOTSTRAP_VERSION})" -O "${go_archive}"
echo "${GOLANG_BOOTSTRAP_SHA256}  ${go_archive}" | sha256sum -c -

# Extract bootstrap package.
tar -C "${bootstrap_prefix}" -xzf "${go_archive}"

# Remove bootstrap package.
rm -f "${go_archive}"

# Build bootstrap package.
cd "${goroot_bootstrap}/src"
./make.bash

# Download golang archive.
wget -q "$(golang_url ${GOLANG_VERSION})" -O "${go_archive}"
echo "${GOLANG_SRC_SHA256}  ${go_archive}" | sha256sum -c -

# Extract golang archive.
tar -C "${prefix}" -xzf "${go_archive}"

# Remove golang archive.
rm -f "${go_archive}"

# Build golang.
export GOROOT_BOOTSTRAP=${goroot_bootstrap}
cd "${go_root}/src"
./make.bash

# Remove bootstrap package.
rm -rf "${bootstrap_prefix}"

# Delete golang build dependencies.
apk del --purge golang-dependencies
