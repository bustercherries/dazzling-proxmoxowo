# dazzling-proxmoxowo
Proxmox stuff/ DevOps alike

## VM_creation
1. Firstly in the console on localhost where the script is stored:
read -p "Enter the ID of new VM: " VMID
2. Then: 
ssh root@192.168.10.9 'bash -s' -- "$VMID" < VM_creation.sh
3. After installation is done there is a need to unmount cdrom:
(from console using root user of Proxmox):
ssh root@192.168.10.9 'qm set 33333 --cdrom none'
then reboot:
ssh root@192.168.10.9 'qm reboot 3333'

## userapp_creation

