#!/bin/bash
# Install Elastic Search
LINE="----------------------------------------------------------------"

echo "Getting PGP key"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sleep 1
echo $LINE

echo "Adding ElasticSearch to APT sources"
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sleep 1
echo $LINE

echo "Updating & Installing Debian packages"
sudo apt-get update && sudo apt-get install elasticsearch
sleep 1

echo "All done. Hooray"
