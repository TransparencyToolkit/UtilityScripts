#!/bin/bash
# Install Harvester

echo "Getting Debian dependencies"
sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev mongodb

echo "Getting Harvester codebase"
git clone https://github.com/TransparencyToolkit/Harvester
cd Harvester
bundle install
