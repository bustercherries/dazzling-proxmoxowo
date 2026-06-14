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