#!/bin/bash
# Look up the serial number of the cert to revoke on the cert itself on the webserver
# By default it should be 1000

openssl ca -revoke data/ssl/newcerts/$1.pem -config data/ssl/bitwarden.ext
