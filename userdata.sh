#!/bin/bash
yum update -y
yum install nginx -y
cp /tmp/index.html /var/www/html/index.html
chmod 755 /var/www/index.html
service nginx restart
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --reload
