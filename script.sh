#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
set -u

## importnant viariables
working_dir=$1
lock_file="tmp/script-lock-file"
cmd_rm="rm -f"
cmd_mv="mv"
cmd_find=(find . -maxdepth 1 -type f -name "*.config*" -printf "%p\n")
config_file_name="config"

## Removing lock file - used in many cases
function remove_lock_file() {
    if [ -f "$lock_file" ]; then
        $cmd_rm "$lock_file" || {
            echo "Cannot remove lock file; ${lock_file}" >$2;
            exit 4
        }
    fi
}

## Checking if lock file exists
if [ -e "${lock_file}" ]; then
    echo "Lock file exists; another instance is running? ${lock_file}" >$2;
    exit 1
fi

## create a lock file
touch "${lock_file}" || {
    echo "Cannot create lock file - exiting; ${lock_file}" >$2;
    exit 2
}

## go to working dir
cd "$working_dir" || {
    echo "Cannot change directory to ${working_dir}" >$2;
    remove_lock_file
    exit 3
}


### downloading the ISO from ubuntu page
cd /var/lib/vz/template/iso
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso


### VMs varibales
VMID = 6000
VM_NAME = "$VMID -VM"
MEMORY = 2048
CORES = 2
BRIDGE = "vmbr0"
STORAGE = "local-lvm"


### check if VM exists
vm_exists(){
  qm status "$VMID" >/dev/null/ 2>$1
}

if ! vm_exists; then
  echo "VM with ID $VMID does not exist. Creating a new VM."
else
  echo "VM with ID $VMID already exists. Exiting."
  exit 1
fi

qm create "$VMID" --name "$VM_NAME" \
  --memory "$MEMORY" \
  --cores "$CORES" \
  --net0 virtio,bridge=$BRIDGE,firewall=1 \
  --ostype l26 \
  --scsihw virtio-scsi-pci \
  --scsi0 local-lvm:32

### attaching ISO 
qm set "$VMID" --cdrom local:iso/ubuntu-22.04.5-live-server-amd64.iso

### enabling booting from ISO
qm set "$VMID" --boot order=scsi0;ide2

### start VM
qm start "$VMID"

### installation in progress via gui?

### after installation, detach ISO 
qm set "$VMID" --cdrom none

### checking the status of newy created VM
if [ "$(qm status "$VMID")" = "running" ]; then
  echo "VM with ID $VMID is running."
else
  echo "VM with ID $VMID is not running, starting it now."
  qm start "$VMID"
fi



## finishing work
echo "Script finished successfully"
remove_lock_file