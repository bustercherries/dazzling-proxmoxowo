# documentation: https://docs.docker.com/engine/install/ubuntu/

ssh userapp@192.168.10.219 "sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)"

# using the conveniance script (not recommendedd for production servers)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh --dry-run

# post installation
# adding to docker group

sudo groupadd docker
sudo usermod -aG docker userapp
