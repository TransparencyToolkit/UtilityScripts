#!/bin/bash
# Install Basics

echo "Installing Debian dependencies"
sudo apt-get install apt-transport-https build-essential

echo "Installing RVM"
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc

gpg --verify rvm-installer.asc

echo "Install RVM with: ./rvm-installer ruby-2.4.1"
bash rvm-installer stable

sudo gem install bundler rails
