## Move to the directory you created
mkdir ./immich-app
cd ./immich-app

## Get docker-compose.yml file
wget -O docker-compose.yml https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml

## Get .env file
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env