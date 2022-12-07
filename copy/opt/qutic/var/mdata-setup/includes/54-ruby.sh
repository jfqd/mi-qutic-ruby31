#!/bin/bash

if mdata-get server_name 1>/dev/null 2>&1; then
  SERVER_NAME=`mdata-get server_name`
  sed -i "s:SERVER_NAME:$SERVER_NAME:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
else
  sed -i "s:ServerName SERVER_NAME::g" /opt/local/etc/httpd/vhosts/01-ruby.conf
fi

if mdata-get server_name 1>/dev/null 2>&1; then
  SERVER_ALIAS=`mdata-get server_alias`
  sed -i "s:SERVER_ALIAS:$SERVER_ALIAS:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
else
  sed -i "s:ServerAlias SERVER_ALIAS::g" /opt/local/etc/httpd/vhosts/01-ruby.conf
fi

if mdata-get server_port 1>/dev/null 2>&1; then
  SERVER_PORT=`mdata-get server_port`
  sed -i "s:SERVER_PORT:$SERVER_PORT:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
  # enable ssh
  if SERVER_PORT = "443"; then
    touch /opt/local/etc/httpd/certs/cert.pem
    touch /opt/local/etc/httpd/certs/key.pem
    sed -i "s:# SSLEngine:SSLEngine:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
    sed -i "s:# SSLCertificateFile:SSLCertificateFile:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
    sed -i "s:# SSLCertificateKeyFile:SSLCertificateKeyFile:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
  fi
else
  sed -i "s:Listen SERVER_PORT::g" /opt/local/etc/httpd/vhosts/01-ruby.conf
  sed -i "s:SERVER_PORT:80:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
fi

MAXINSTANCES=10
if mdata-get passenger_maxinstances 1>/dev/null 2>&1; then
  MAXINSTANCES=`mdata-get passenger_maxinstances`
fi
sed -i "s:MAXINSTANCES:$MAXINSTANCES:g" /opt/local/etc/httpd/conf.d/99-passenger.conf

WORKERS=4
if mdata-get passenger_workers 1>/dev/null 2>&1; then
  WORKERS=`mdata-get passenger_workers`
fi
sed -i "s:WORKERS:$WORKERS:g" /opt/local/etc/httpd/vhosts/01-ruby.conf
sed -i "s:WORKERS:$WORKERS:g" /opt/local/etc/httpd/conf.d/99-passenger.conf

# Enable apache by default
/usr/sbin/svcadm enable svc:/pkgsrc/apache:default
