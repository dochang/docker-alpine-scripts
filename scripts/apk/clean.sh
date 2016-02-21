#!/bin/sh

set -ex

[ -z "$(ls /var/cache/apk)" ] || rm -rf /var/cache/apk/*
