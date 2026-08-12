#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
set -u

### downloading the ISO from ubuntu page
ISO_PATH="/var/lib/vz/template/iso/ubuntu-22.04.5-live-server-amd64.iso"
mkdir -p /var/lib/vz/template/iso
cd /var/lib/vz/template/iso
if [ ! -f "$ISO_PATH" ]; then
    wget https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso
else
    echo "ISO already exists at $ISO_PATH"
fi


### VMs varibales
VMID=6000
VM_NAME="$VMID-VM"
MEMORY=2048
CORES=2
BRIDGE="vmbr0"
STORAGE="local-lvm"


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

