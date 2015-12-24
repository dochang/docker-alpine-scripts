#!/bin/sh

set -ex

ANSIBLE_HOME=/opt/ansible

inventory_dir=/etc/ansible
cd /
rm -rf "${ANSIBLE_HOME}"
rm -rf ${inventory_dir}

rm -rf $HOME/.ansible
