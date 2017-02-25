#!/bin/bash
# Install Transparency Toolkit's LookingGlass

echo "Getting Debian dependencies"
sleep 1
sudo apt-get install ruby-full

echo "Getting Looking Glass codebase"
sleep 1
git clone https://github.com/TransparencyToolkit/LookingGlass
cd LookingGlass
bundle install
