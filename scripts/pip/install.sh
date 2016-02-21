#!/bin/sh

set -ex

pip_deps='python curl openssl ca-certificates python-dev build-base'
apk add --no-cache --virtual pip-dependencies ${pip_deps}

curl -sSL https://bootstrap.pypa.io/get-pip.py | python

pip install virtualenv pip-autoremove
