#!/bin/bash
# Install Basics

echo "Add environment variables"
export TT_APPS="/home/${USER}/TransparencyToolkit" 
export TT_DATA="/home/${USER}/Data/"
export TT_DM_HOST="127.0.0.1"
export TT_DM_PORT="3000"
export TT_HS_HOST="127.0.0.1"
export TT_HS_PORT="3333"
export TT_CT_HOST="127.0.0.1"
export TT_CT_PORT="3002"
export TT_LG_HOST="127.0.0.1"
export TT_LG_PORT="3001"

echo "Installing Debian dependencies"
sudo apt-get install apt-transport-https build-essential

echo "Installing RVM"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc

gpg --verify rvm-installer.asc

echo "Install RVM with: ./rvm-installer ruby-2.4.1"
bash rvm-installer stable

gem install bundler rails
