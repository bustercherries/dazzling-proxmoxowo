#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
set -u

### Variables
USERNAME="adminapp"

### Update the system
#sudo apt update
#sudo apt upgrade

### install vim
#sudo apt install vim

## 1. User app creation
### install the ssh service
if ! dpkg --status openssh-server; then
    sudo apt install openssh-server
else 
    echo "Hi You! Openssh already installed."
fi

: <<'COMMENT'
### userapp creation
if ! id "$USERNAME"; then
    echo "User $USERNAME cannot be found, creating it."
    adduser --disabled-password --gecos "" $USERNAME
    usermod -aG sudo $USERNAME
    sudo mkdir -p /home/$USERNAME/.ssh
    sudo chmod 700 /home/$USERNAME/.ssh
else
    echo "User $USERNAME already exits."
fi


### userapp without asking for a password

echo "$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/docker" | sudo tee /etc/sudoers.d/$USERNAME
sudo chmod 0440 /etc/sudoers.d/$USERNAME
sudo visudo -c -f /etc/sudoers.d/$USERNAME

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
COMMENT

# checking if docker has been installed
docker --version

### 3. Set up Immich directory and files
## create a directory for immich
#mkdir ./immich-app
cd ./immich-app

## Get docker-compose.yml file
wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml

## Get .env file
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env

### STOPPED HERE

# You can find documentation for all the supported env variables at https://docs.immich.app/install/environment-variables

# The location where your uploaded files are stored
UPLOAD_LOCATION=./library

# The location where your database files are stored. Network shares are not supported for the database
DB_DATA_LOCATION=./postgres

# To set a timezone, uncomment the next line and change Etc/UTC to a TZ identifier from this list: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List
# TZ=Etc/UTC

# The Immich version to use. You can pin this to a specific version like "v2.1.0"
IMMICH_VERSION=v3

# Connection secret for postgres. You should change it to a random password
# Please use only the characters `A-Za-z0-9`, without special characters or spaces
DB_PASSWORD=postgres

# The values below this line do not need to be changed
###################################################################################
DB_USERNAME=postgres
DB_DATABASE_NAME=immich