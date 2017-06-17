#!/bin/bash
# Install Elastic Search
LINE="----------------------------------------------------------------"

echo "Installing Debian dependencies"
sudo apt install openjdk-8-jre
sleep 1

echo "Getting ElasticSearch PGP key"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sleep 1
echo $LINE

echo "Adding ElasticSearch to APT sources"
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
sleep 1
echo $LINE

echo "Updating & Installing ElasticSearch"
sudo apt update && sudo apt install elasticsearch
sleep 1

echo "All done. Hooray"
echo "Run by typing: sudo service elasticsearch start"
echo "You might need to lower / raise RAM in '/etc/elasticsearch/jvm.options'"
echo "  -Xms1g" 
echo "  -Xmx1g"

