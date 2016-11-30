#!/bin/sh

# Inspired by https://github.com/docker-library/golang/blob/master/1.6/alpine/Dockerfile

set -ex

export GOLANG_VERSION=1.7.3
export GOLANG_SRC_SHA256=79430a0027a09b0b3ad57e214c4c1acfdd7af290961dd08d322818895af1ef44

prefix=/usr/local
go_archive=/golang.tar.gz
go_root=${prefix}/go

# https://golang.org/issue/14851
no_pic_patch="$(dirname $0)/no-pic.patch"

golang_url() {
	printf "https://golang.org/dl/go%s.src.tar.gz" "$1"
}

# Install golang build dependencies.
apk add --no-cache --virtual golang-dependencies bash ca-certificates gcc musl-dev openssl tar go

export GOROOT_BOOTSTRAP="$(go env GOROOT)"

# Download golang archive.
wget -q "$(golang_url ${GOLANG_VERSION})" -O "${go_archive}"
echo "${GOLANG_SRC_SHA256}  ${go_archive}" | sha256sum -c -

# Extract golang archive.
tar -C "${prefix}" -xzf "${go_archive}"

# Remove golang archive.
rm -f "${go_archive}"

# Build golang.
cd "${go_root}/src"
patch -p2 -i "${no_pic_patch}"
./make.bash

# Delete golang build dependencies.
apk del --purge golang-dependencies
