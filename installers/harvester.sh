#!/bin/bash
# Install Harvester

echo "Getting Debian dependencies"
sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev mongodb
sleep 2

echo "Adding Dotdeb repository and GPG key"
echo "deb http://ftp.utexas.edu/dotdeb/ stable all \n deb-src http://ftp.utexas.edu/dotdeb/ stable all" | sudo tee /etc/apt/sources.list.d/dotdeb.list | cat
wget -O $TT_APPS/dotdeb.gpg https://www.dotdeb.org/dotdeb.gpg
sudo apt-key add dotdeb.gpg
rm $TT_APPS/dotdeb.gpg
sleep 2

echo "Installing Redis"
sudo apt-get update
sudo apt-get install redis-server
sleep 2

echo "Getting Harvester codebase"
PATH_HARVESTER="$TT_APPS/Harvester/"
git clone https://github.com/TransparencyToolkit/Harvester $PATH_HARVESTER
cd $PATH_HARVESTER
bundle install
sleep 2

echo "Done installing Harvester. Time to disco."
