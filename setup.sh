#!/usr/bin/env bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

mkdir -p /opt/Bitwarden-Backup
echo "Backup folder has been created at /opt/Bitwarden-Backup"

chmod +x get-docker.sh
./get-docker.sh
sudo service docker enable
usermod -aG docker $USER
apt install -y libffi-dev libssl-dev
apt install -y python3 python3-pip
pip3 install docker-compose

clear
echo "Would you like to create your own personal CA and SSL certificate to enable HTTPS with bitwarden?"
select yn in "Yes" "No"; do
    case $yn in
	Yes ) sudo ./create_ssl.sh && break;;
	No ) echo "Make sure to load your own SSL certs into ./data/ssl for the Nginx container to use" && break;;
    esac
done
echo ""
echo "Docker and Docker-Compose have been installed, it is recommended to restart to make sure everything is installed correctly"
echo "Would you like to restart?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo reboot && break;;
        No ) exit;;
    esac
done



