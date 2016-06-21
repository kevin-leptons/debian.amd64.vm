# debian.amd64.vm
virtual machine of debian 8 amd64

information

- os: debian 8
- virtual machine host: virtual box
- hdd file compress: ~1GB
- hdd file extract: ~4GB

# installation

## download virtual machine hdd
because hdd is large file, it is imposible to put it into git directory. i use
google drive, but we can not get direct link to download. so you must download
virtual machine hdd by hand. link to download page here 
[debian.amd64.vdi.tar.gz](https://drive.google.com/open?id=0B6Eqm2oY7b1vZDdYNmRkbmJhMmM)

after download completed, i denote path to file is `$vm_hdd_gz_path`. it will
be use to install virtual machine below

## install virtual machine
```shell
# 
git clone https://github.com/kevin-leptons/debian.amd64.vm.git
cd debian.amd64.vm.git

# this command will extract hdd file to vms/ directory, create new virtual
# machine with name debian.amd64
./vmctl.sh install $vm_hdd_gz_path
```

## delete virtual machine
```shell
# this command delete virtual machine, does not delete hdd file
./vmctl.sh remove
```

# usage


## active virtual machine
```shell
./vmctl.sh active
```

## save then virtual machine
```shell
./vmctl.sh save
```
