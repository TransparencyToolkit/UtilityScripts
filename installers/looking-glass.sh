#!/bin/bash
# Install Transparency Toolkit's LookingGlass

echo "Getting Debian dependencies"
sleep 1
sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev 
sleep 1

echo "Getting Looking Glass codebase"
sleep 1

PATH_LG="$TT_APPS/LookingGlass"
git clone https://github.com/TransparencyToolkit/LookingGlass $PATH_LG
cd $PATH_LG
sleep 1

echo "Installing ruby gems"
bundle install
sleep 1
