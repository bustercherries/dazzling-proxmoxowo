### inside the VM, via terminal

### check for SSH service
systemctl status ssh
### if not existing:
sudo apt install openssh-server

## login via ssh to newly created VM

## Creating userapp
sudo adduser --gecos "" userapp
sudo usermod -aG sudo userapp
sudo mkdir -p /home/userapp/.ssh
sudo chmod 700 /home/userapp/.ssh


## coping SSH key from localhost to the VM
### the owner of the /home/userapp/.ssh should be userapp not other user - in the /home/userapp:
sudo chmod -R userapp:userapp ~
### then from localhost:
ls ~/.ssh
ssh-copy-id -i ~/.ssh/id_rsa.pub userapp@192.168.10.219


### adding passwordless sudo for the userapp
echo "userapp ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/userapp

### one liner for disabling ssh 
ssh userapp1@ip
sudo vi etc/ssh/sshd_config
#PermitRootLogin no
sudo systemctl restart sshd

# as it turns out permitrootlogin is a global variable
# so this works out:
ssh userapp@192.168.10.219 "echo 'DenyUsers userapp2' | sudo tee -a /etc/ssh/sshd_config && sudo systemctl restart sshd"


ssh userapp@192.168.10.219 "echo 'DenyUsers userapp2' | sudo tee /etc/sshd_config.d/01_denyusers.conf && sudo systemctl reload sshd && sudo systemctl restart sshd"
