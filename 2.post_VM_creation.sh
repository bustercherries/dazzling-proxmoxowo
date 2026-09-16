#!/bin/bash

##in case of any error without pipeline, exit the script
set -e

## exit if there is unbound (unused) variable 
set -u

### Variables

## 1. User app creation
sudo apt install openssh-server

### 2. Install docker + compose
### 3. Set up Immich directory and files
## Move to the directory you created
mkdir ./immich-app
cd ./immich-app

## Get docker-compose.yml file
wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml

## Get .env file
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env

### 4. Get docker-compose.yml and .env tempalte

# Configure .env

### Start immich