# dazzling-proxmoxowo
Proxmox stuff/ DevOps alike

## VM_creation
1. Firstly in the console on localhost where the script is stored:
read -p "Enter the ID of new VM: " VMID
2. Then: 
ssh root@192.168.10.9 'bash -s' -- "$VMID" < VM_creation.sh

## userapp_creation

