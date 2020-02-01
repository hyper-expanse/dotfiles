#!/usr/bin/env bash

files=(deploy.sh)

for file in ${files[*]}; do
  shellcheck "${file}"
done
