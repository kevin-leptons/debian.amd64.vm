#!/bin/bash

# spec      : active virtual machine and connect to it via ssh
# author    : kevin.leptons@gmail.com

# shell options
set -e

# variables
vm_name="debian.amd64"
vm_cpus="2"
vm_ram="512"
vm_disk_path="vms/debian.amd64.vdi"

# vm.install
if ! vboxmanage list vms | grep $vm_name> /dev/null; then
    # create virutal machine
    # and configure it
    vboxmanage createvm --name "$vm_name" --register
    vboxmanage modifyvm "$vm_name" \
        --memory $vm_ram \
        --acpi on \
        --nic1 bridged --bridgeadapter1 eth0
    vboxmanage storagectl "$vm_name" \
        --name "sata-controller" \
        --add sata
    vboxmanage storageattach "$vm_name" \
        --storagectl "sata-controller" \
        --port 0 \
        --device 0 \
        --type hdd \
        --medium "$vm_disk_path"
fi

# vm.active
if ! vboxmanage list runningvms | grep $vm_name > /dev/null; then
    vboxmanage startvm "$vm_name" --type headless
fi

# connect
ssh kevin@debian.amd64.vm
