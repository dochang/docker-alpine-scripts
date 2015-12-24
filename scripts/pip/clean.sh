#!/bin/sh

set -ex

pip freeze | xargs pip uninstall --yes
# Also uninstall setuptools & pip
#
# https://github.com/pypa/pip/issues/2989
# https://github.com/pypa/pip/blob/7.1.0/pip/operations/freeze.py#L16
pip uninstall --yes setuptools pip

apk del --purge pip-dependencies

rm -rf $HOME/.cache/pip
