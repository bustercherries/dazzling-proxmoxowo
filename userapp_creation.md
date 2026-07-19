### inside the VM, via termimal

### check for SSH service
systemctl status ssh

## Creating userapp
sudo adduser userapp
sudo usermod -aG sudo userapp
sudo mkdir -p /home/userapp/.ssh
sudo chmod 700 /home/userapp/.ssh

### tu nie dodawaj userapp do passwordless bo smieszny blad

## coping SSH key from my laptop to the VM
### on my laptop
### to check the shh keys 
(Powershell) ls ~/.ssh
ssh-copy-id -i ~/.ssh/id_ed25519.pub userapp@192.168.10.219

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
