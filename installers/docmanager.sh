#! /bin/bash
# Install DocManager

echo "Installing system depedencies"
sudo apt install mongodb
sleep 1

echo "Cloning DocManager"
git clone git@github.com:TransparencyToolkit/DocManager
sleep 1

cd DocManger
bundle install
sleep 1

echo "All installed. Hooray"
