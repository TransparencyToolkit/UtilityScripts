#!/bin/bash
# Install Harvester

echo "Getting Debian dependencies"
sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev mongodb
sleep 2

echo "Installing Redis"
sudo apt-get install redis-server
sleep 2

echo "Getting Harvester codebase"
PATH_HARVESTER="$TT_APPS/Harvester/"
git clone https://github.com/TransparencyToolkit/Harvester $PATH_HARVESTER
cd $PATH_HARVESTER
bundle install
sleep 2

echo "Done installing Harvester. Time to disco."
