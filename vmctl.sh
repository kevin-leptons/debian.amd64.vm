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
vm_hdd_cpath="vms/debian.amd64.vdi.tar.gz"
vm_user="dev"
vm_ipaddr="192.168.1.4"

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
    if [ ! -f $vm_hdd_path ]; then
        echo "hdd"
        #tar -xvf "$1" --directory "$vm_dir"
    fi

    # vm.create
    if ! vboxmanage list vms | grep $vm_name> /dev/null; then
        # create virutal machine
        # and configure it
        vboxmanage createvm --name "$vm_name" --register
        vboxmanage modifyvm "$vm_name" \
            --ioapic on \
            --cpus $vm_cpus \
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
    rm -rf ~/VirtualBox\ VMs/$vm_name
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
    echo "use: $0 install hdd-gz-path | remove | start | ssh | display | save"
}

# spec      : connect to virtual machine by ssh
# arg       : none
#   - 0 on success
#   - 1 on error
function vm_ssh()
{
    ssh "$vm_user@$vm_ipaddr"
}

# spec      : show display of virtual machine
# arg       : none
#   - 0 on success
#   - 1 on error
function vm_display()
{
    virtualbox --startvm "$vm_name" --no-startvm-errormsgbox --separate
}

# spec      : compress virtual machine hdd
# arg       : none
# ret       :
#   - 0 on success
#   - 1 on error
function vm_hdd_compress()
{
    mkdir -vp "$vm_dir"
    rm -fv "$vm_hdd_cpath"
    tar -zcvf "$vm_hdd_cpath" "$vm_hdd_path"
}

# swtich command
case $1 in
    "install") vm_install $2;;
    "remove") vm_remove;;
    "start") vm_start;;
    "ssh") vm_ssh;;
    "display") vm_display;;
    "save") vm_save;;
    "compress") vm_hdd_compress;;
    *) vmctl_help;;
esac

