#!/bin/bash
# Look up the serial number of the cert to revoke on the cert itself on the webserver
# By default it should be 1000

if [ $# = 0 ]
then
  cert=1000
else
  cert=$1
fi

cp data/ssl/certs/bitwarden.crt data/ssl/certs/bitwarden.crt.bak
openssl ca -revoke data/ssl/newcerts/$cert.pem -config data/ssl/bitwarden.ext
openssl ca -config data/ssl/bitwarden.ext -extensions server_cert -days 365 -notext -md sha256 -in data/ssl/csr/bitwarden.csr -out data/ssl/certs/bitwarden.crt
