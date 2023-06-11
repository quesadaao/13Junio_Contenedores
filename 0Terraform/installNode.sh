#!/bin/sh
cd ~/
sudo apt update && sudo apt upgrade -y
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt install npm -y
sudo npm install pm2@latest -g
sudo mkdir ~/app/
sudo chmod 777 ~/app/
sudo cp /tmp/default_node.js ~/app/default_node.js
chmod 770 ~/app/default_node.js
pm2
sudo chmod a+rw .pm2
sudo pm2 start ~/app/default_node.js
sudo apt-get install -y nginx
sudo cp /tmp/nginx.conf /etc/nginx/sites-available/default
sudo systemctl restart nginx