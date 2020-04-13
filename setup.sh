#!/usr/bin/env bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker $USER
sudo apt-get install -y libffi-dev libssl-dev
sudo apt-get install -y python3 python3-pip
sudo pip3 install docker-compose
chmod +x create_ssl.sh
sudo ./create_ssl.sh
echo "Docker and Docker-Compose have been installed, it is recommended to restart to make sure everything is installed correctly"
echo "Would you like to restart?"
select yn in "Y" "N"; do
    case $yn in
        Y ) sudo reboot;;
        N ) exit;;
    esac
done



