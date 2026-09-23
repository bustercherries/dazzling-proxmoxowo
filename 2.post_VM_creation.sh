#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
set -u

### Variables
USERNAME="adminapp"

## 1. User app creation
### install the ssh service
if ! dpkg --status openssh-server; then
    sudo apt install openssh-server
else 
    echo "Openssh already installed"
fi

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

### 2. Install docker + compose
### 3. Set up Immich directory and files
## Move to the directory you created
