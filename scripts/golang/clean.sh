#!/bin/sh

set -ex

prefix=/usr/local
go_root=${prefix}/go
bootstrap_prefix=${prefix}/bootstrap
go_archive=/golang.tar.gz

# Clean golang packages
rm -rf "${go_root}" "${go_archive}" "${bootstrap_prefix}"
