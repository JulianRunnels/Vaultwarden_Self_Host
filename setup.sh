#!/usr/bin/env bash
apt install docker
usermod -aG docker $USER
apt install -y libffi-dev libssl-dev
apt install -y python3 python3-pip
pip3 install docker-compose
clear
echo "Creating SSL CA and certificates"
chmod +x create_ssl.sh
./create_ssl.sh
echo "Docker and Docker-Compose have been installed, it is recommended to restart to make sure everything is installed correctly"
echo "Would you like to restart?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) sudo reboot;;
        No ) exit;;
    esac
done



