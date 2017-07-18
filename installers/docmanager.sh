#! /bin/bash
# Install DocManager

echo "Installing system depedencies"
sudo apt install mongodb
sleep 1

echo "Cloning DocManager"
PATH_DOCMANAGER="$TT_APPS/DocManager"
git clone https://github.com/TransparencyToolkit/DocManager $PATH_DOCMANAGER
sleep 1

cd $PATH_DOCMANAGER
bundle install
sleep 1

echo "All installed. Hooray"
