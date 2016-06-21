#!/bin/bash

# spec      : install virutal machine
# author    : kevin.leptons@gmail.com
# use       : vm-hdd-install vm-hdd-gz-path

# bash options
set -e

# variable
vm_name="debian.amd64"
vm_dir="vms"
vm_hdd_gz_path="$1"
vm_hdd_path="vms/debian.amd64.vdi"

# verify gzip file
if [ "$vm_hdd_gz_path" =  "" ]; then
    (>&2 echo "use: $0 vm-hdd-gz-path")
    exit 1
fi

# extract
tar -xvf "$vm_hdd_gz_path" --directory "$vm_dir"
