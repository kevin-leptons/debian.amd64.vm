#!/bin/bash

# spec      : control virtual machine
# author    : kevin.leptons@gmail.com

# shell options
set -e

# variables
vm_dir="vms"
vm_name="debian.amd64"
vm_cpus="2"
vm_ram="512"
vm_hdd_path="vms/debian.amd64.vdi"

# spec      : install virtual machine
# arg       :
#   - hdd_gz_path: path to compressed hdd file
# ret       :
#   - 0 on success
#   - 1 on error
function vm_install() 
{
    # vm.hdd.install
    mkdir -vp $vm_dir
    tar -xvf "$1" --directory "$vm_dir"

    # vm.create
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
            --medium "$vm_hdd_path"
    fi
}

# spec      : active virtual machine
# arg       : none
# ret       : 
#   - 0 on success
#   - 1 on error
function vm_start()
{
    if ! vboxmanage list runningvms | grep $vm_name > /dev/null; then
        vboxmanage startvm "$vm_name" --type headless
    fi
}

# spec      : remove virutal machine, does not remove hdd file
# arg       : none
#   - 0 on success
#   - 1 on error
function vm_remove()
{
    vboxmanage unregistervm "$vm_name"
}

# spec      : save then stop virtual machine
# arg       : none
# ret       :
#   - 0 on success
#   - 1 on error
function vm_save()
{
    vboxmanage controlvm "$vm_name" savestate
}

# spec      : show help for command
# arg       : none
# ret       :
#   - 0 on success
#   - 1 on error
function vmctl_help()
{
    (>2& echo "use: $0 install hdd-gz-path | remove | active | save")
}

# spec      : connect to virtual machine by ssh
# arg       : none
#   - 0 on success
#   - 1 on error
function vm_ssh()
{
    ssh kevin@debian.amd64.vm
}

# spec      : show display of virtual machine
# arg       : none
#   - 0 on success
#   - 1 on error
function vm_display()
{
    virtualbox --startvm "$vm_name" 
}

# swtich command
case $1 in
    "install") vm_install $2;;
    "remove") vm_remove;;
    "start") vm_start;;
    "ssh") vm_ssh;;
    "display") vm_display;;
    "save") vm_save;;
    *) vmctl_help;;
esac

