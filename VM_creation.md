# downloading the ISO from ubuntu page
cd /var/lib/vz/template/iso
wget https://releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso

# creating first ubuntu VM from Proxmox shell 

qm create 6000 --name ubuntu-shell \
  --memory 4096 \
  --cores 2 \
  --net0 virtio,bridge=vmbr0,firewall=1 \
  --ostype l26 \
  --scsihw virtio-scsi-pci \
  --scsi0 local-lvm:32

## deleting VM
qm destroy 6000

# attaching ISO 
qm set 6000 --cdrom local:iso/ubuntu-22.04.5-live-server-amd64.iso

# enabling booting from ISO
qm set 6000 --boot order=scsi0;ide2

# start VM
qm start 6000

# after installation, detach ISO 
qm set 6000 --cdrom none
