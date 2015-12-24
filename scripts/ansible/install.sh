#!/bin/sh

set -ex

export ANSIBLE_HOME=/opt/ansible

mkdir -p $(dirname ${ANSIBLE_HOME})
virtualenv "${ANSIBLE_HOME}"
. "${ANSIBLE_HOME}/bin/activate"
pip install ansible

inventory_dir=/etc/ansible
group_vars_dir=${inventory_dir}/group_vars/local
mkdir -p ${group_vars_dir}
printf '[local]\nlocalhost\n' > ${inventory_dir}/hosts
printf '---\nansible_connection: local\n' > ${group_vars_dir}/main.yml

deactivate
