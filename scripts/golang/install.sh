#!/bin/sh

# Inspired by https://github.com/docker-library/golang/blob/master/1.5/alpine/Dockerfile

set -ex

export GOLANG_VERSION=1.6.2
export GOLANG_SRC_SHA256=787b0b750d037016a30c6ed05a8a70a91b2e9db4bd9b1a2453aa502a63f1bccc

export GOLANG_BOOTSTRAP_VERSION=1.4.3
export GOLANG_BOOTSTRAP_SHA256=9947fc705b0b841b5938c48b22dc33e9647ec0752bae66e50278df4f23f64959

prefix=/usr/local
bootstrap_prefix=${prefix}/bootstrap
goroot_bootstrap=${bootstrap_prefix}/go
go_archive=/golang.tar.gz
go_root=${prefix}/go

# https://golang.org/issue/14851
no_pic_patch="$(dirname $0)/no-pic.patch"

# https://golang.org/issue/13114
# alpinelinux/aports@b63af71
new_binutils_patch="$(dirname $0)/new-binutils.patch"

golang_url() {
	printf "https://golang.org/dl/go%s.src.tar.gz" "$1"
}

# Install golang build dependencies.
apk add --no-cache --virtual golang-dependencies bash ca-certificates gcc musl-dev openssl tar

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
patch -p2 -i "${new_binutils_patch}"
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
patch -p2 -i "${no_pic_patch}"
./make.bash

# Remove bootstrap package.
rm -rf "${bootstrap_prefix}" "${go_root}/pkg/bootstrap"

# Delete golang build dependencies.
apk del --purge golang-dependencies
