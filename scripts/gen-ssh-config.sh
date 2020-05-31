#!/bin/bash
if [ -z "${1}" ]; then 
  echo "ERROR:  Service name (\$1) is required" 1>&2
  exit 1
fi
vagrant ssh-config > ssh-config
echo -e "[vagrant]\n${1}" > hosts
