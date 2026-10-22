#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
set -u

## show error in what line
trap 'echo "Error in line $LINENO"' ERR

### Variables
USERNAME="userapp"

### install vim
#sudo apt install vim

## 1. User app creation
### install the ssh service
if ! dpkg --status openssh-server; then
    sudo apt install openssh-server
else 
    echo "Hi You! Openssh already installed."
fi

### userapp creation
if ! id "$USERNAME"; then
    echo "User $USERNAME cannot be found, creating it."
    sudo adduser --disabled-password --gecos "" "$USERNAME"
    sudo usermod -aG sudo $USERNAME
    sudo mkdir -p /home/$USERNAME/.ssh
    sudo chmod 700 /home/$USERNAME/.ssh
    sudo chown -R $USERNAME:$USERNAME /home/$USERNAME
else
    echo "User $USERNAME already exits."
fi

### userapp without asking for a password
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/$USERNAME" >/dev/null
sudo usermod -aG docker $USERNAME
sudo chmod 0440 /etc/sudoers.d/$USERNAME
### validation:
sudo visudo -c -f /etc/sudoers.d/$USERNAME

### removing loging via root via ssh
sudo sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sshd -t || {
    echo "SSH config is invalid. Check it."
    exit 1
}
sudo systemctl restart ssh

### 2. Install docker + compose
echo "Installing the docker now."
curl -fvSL https://get.docker.com -o get-docker.sh

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<_EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
_EOF

sudo apt update

# install docker packages
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# checking if docker has been installed
docker --version

### 3. Set up Immich directory and files
## create a directory for immich
echo "Now installing immich."
sudo mkdir -p /opt/immich-app
sudo chown -R "$USERNAME:$USERNAME" /opt/immich-app
cd /opt/immich-app

whoami
pwd
ls -ld .

## Get docker-compose.yml file
[ -f docker-compose.yml ] || wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml

## Get .env file
[ -f .env ] || wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env


# You can find documentation for all the supported env variables at https://docs.immich.app/install/environment-variables

# The location where your uploaded files are stored
UPLOAD_LOCATION="/opt/immich-app/library"
sudo mkdir -p "$UPLOAD_LOCATION"

# The location where your database files are stored. Network shares are not supported for the database
DB_DATA_LOCATION="/opt/immich-app/postgres"
sudo mkdir -p "$DB_DATA_LOCATION"

# Changing the path of upload and db location 
cd /opt/immich-app/
sudo sed -i "s|^UPLOAD_LOCATION=.*|UPLOAD_LOCATION=$UPLOAD_LOCATION|" .env
sudo sed -i "s|^DB_DATA_LOCATION=.*|DB_DATA_LOCATION=$DB_DATA_LOCATION|" .env

## start containers
sudo docker compose up -d
