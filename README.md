# dazzling-proxmoxowo
Proxmox stuff/ DevOps alike

## VM_creation
1. Firstly in the console on localhost where the script is stored:
read -p "Enter the ID of new VM: " VMID && export VMID
2. Then: 
ssh root@192.168.10.9 'bash -s' -- "$VMID" < 1.VM_creation.sh
* When installing the os on the VM, install  ssh service as well.
sudo apt update
sudo apt install openssh-server
sudo systemctl enable --now ssh

3. After installation is done there is a need to unmount cdrom:
(from console using root user of Proxmox):
ssh root@192.168.10.9 'qm set $VMID --cdrom none'
then reboot:
ssh root@192.168.10.9 'qm reboot $VMID'

## post_VM_creation
1. A temporary solution (?) to copy the script to VM and then run from it. Logging in via admin account not userapp!
scp 2.post_VM_creation.sh roza@192.168.10.43:/tmp/
ssh -t roza@192.168.10.43 "bash /tmp/2.post_VM_creation.sh"


: <<'COMMENT'

COMMENT