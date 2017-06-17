#! /bin/bash
# Install DocManager

echo "Cloning DocManager"
git clone git@github.com:TransparencyToolkit/DocManager

cd DocManger
bundle install

echo "All installed. Hooray"
