#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
#set -u

### downloading the ISO from ubuntu page
ISO_PATH="/var/lib/vz/template/iso/ubuntu-22.04.5-live-server-amd64.iso"
mkdir -p /var/lib/vz/template/iso
cd /var/lib/vz/template/iso
if [ ! -f "$ISO_PATH" ]; then
    wget https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso
else
    echo "ISO already exists at $ISO_PATH"
fi

### checking if its downloaded 
pvesm list local --content iso

### asking user for ID of VM
#read -p "Enter the ID of new VM: " VMID


### VMs varibales
VMID="$1"
VM_NAME="$VMID-VM"
MEMORY=2048
CORES=2
BRIDGE="vmbr0"
STORAGE="local-lvm"

### check if VM exists
vm_exists(){
  qm status "$VMID" >/dev/null 2>&1
}

create_VM(){
  qm create "$VMID" --name "$VM_NAME" \
  --memory "$MEMORY" \
  --cores "$CORES" \
  --net0 virtio,bridge=$BRIDGE,firewall=1 \
  --ostype l26 \
  --scsihw virtio-scsi-pci \
  --scsi0 local-lvm:16

  ### attaching ISO 
  qm set "$VMID" --cdrom local:iso/ubuntu-22.04.5-live-server-amd64.iso 
  qm set "$VMID" --ide2 local:iso/ubuntu-22.04.5-live-server-amd64.iso,media=cdrom

  ### enabling booting from ISO
  qm set "$VMID" --boot "order=scsi0;ide2"

  ### start VM
  qm start "$VMID"
}

if ! vm_exists; then
  echo "VM with ID $VMID does not exist. Creating a new VM."
  create_VM;
else
  echo "VM with ID $VMID already exists. Exiting."
  exit 1
fi

echo "VM $VMID started. Please proceed with the installation via the Proxmox web interface."
# read -p "To detach ISO after installation of Ubuntu press Enter."

### installation in progress via gui?

### after installation, detach ISO 
#qm set "$VMID" --cdrom none

### checking the status of newy created VM
if qm status "$VMID" | grep -q "status: running"; then
  echo "VM with ID $VMID is running."
else
  echo "VM with ID $VMID is not running, starting it now."
  qm start "$VMID"
fi