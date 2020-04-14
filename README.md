# Bitwarden Self Host

For more details please read: Blog coming soon 

This project is aimed at creating a private Bitwarden instance on your local LAN for devices on your personal network to be able to access. The docker-compose files contains 3 containers, the bitwarden unoffical rust backend, an nginx reverse proxy for HTTPS, and a backup container. To faciliate the connection with Bitwarden's iOS apps via HTTPS, we are going to create our own private CA, so we can create trusted certificates, since self-signed certs won't work with the native app.

__PLEASE NOTE THAT THIS SETUP USES [BITWARDEN_RS](https://github.com/dani-garcia/bitwarden_rs) WHICH IS AN UNOFFICAL COMMUNITY CREATED BACKEND. IT IS REGULARLY UPDATED AND HAS SEVERAL ADVANTAGES INCLUDING ABILITY TO RUN ON RASPBERRY PI, A MUCH LOWER OVERALL RESOURCE FOOTPRINT, AND FULL BITWARDEN FUNCTIONALITY, INCLUDING PREMIUM FEATURES__

## To install ##
__Note: to install on a Raspberry Pi, you will need up update the tags for the containers in docker-compose.yml with the values in the comments of that page__

1. `git clone https://github.com/JulianRunnels/Bitwarden_Self_Host.git`
2. `cd Bitwarden_Self_host`
3. `chmod +x ./setup.sh`

From here here are three different installation paths, depending on your existing setup and needs
* No docker/docker-compose installed, want to create a full private CA and client certificate:
  * `sudo ./setup.sh` - This will install docker and docker-compose and has option to guide you through creating the needed CA and certs
* Docker/docker-compose installed, want to create a full private CA and client certificate:
  * `./create_ssl.sh` - This will just create the needed SSL certificates
* Don't want to install docker or create certs, just spin up containers:
  * `sudo docker-compose up -d` - This will just spin up the containers, you will need to supply your own cert in ./data/ssl
  
Once you have all the setup done, you will need to download the personal CA created, which should be called __myCA.crt__ and install it as a trusted root in each client you want to connect to the bitwarden instance. The good news is that once you install this CA, any further personal certs you make with the CA will be automatically trusted and validated, without having to load new certs in.

To download, I recommend just using scp or any other file transfer:
`scp myCA.crt user@external:~`

#### Note for iOS installation ####
After you transfer the cert over to iOS, to have it work with native Bitwarden app, you will need to  _enable full trust_.
To do this:
* Make sure the certificate is installed
* Go to _Settings_ -> _General_ -> _About_ -> _Certificate Trust Settings_ or just search for _Trusted Certificates_  
* Click the switch next to the certificate you installed to switch it to full trust

Once you have the CA installed where you want it, spin up the containers:
* `sudo docker-compose up -d`

You should now be able to access your instance at https://hostname

## Accessing outside of your personal LAN ##

While having an internal password vault is all good, being able to access accounts while outside the house is equally important. 

For my access I have a Raspberry Pi running PiHole, Unbound, and more importantly PiVPN, which allows me to create a split tunnel VPN to send all local LAN request and DNS request back to my home network. This means that for things like my phone and external devices, as long as I have this VPN up, I can access my vault, just like normal.

A good guide to setup PiVPN is here: https://www.smarthomeblog.net/raspberry-pi-vpn/
Once you have PiPVN, or any OpenVPN based solution set up you can enable a split tunnel, so that only DNS traffic and local based traffic is sent back to you home network rather than routing everything through it:

* `sudo vim /etc/openvpn/server.conf`
* Comment out `#push "dhcp-option DNS 10.8.0.1`
* Add the following lines
  * `push "route 192.168.1.0 255.255.255.0"` (Change the 192 value to your personal private ip range)
  * `push "dhcp-option DNS 192.168.1.28"`
  * `push "block-outside-dns"`
* Comment out `#push "redirect-gateway def1"`

Obviously this does put a little bit of a barrier in the way of using Bitwarden, but it is a small tradeoff to have full and complete control over your passwords and other important data. Of course, its very easy to adapt this repo to create a full publicly accessible instance, simply by adding port forwarding in your router, or running it in the cloud. Personally, I would stay away from both of those options, as they defeat the whole purpose of setting up this instance to have a private vault. 
