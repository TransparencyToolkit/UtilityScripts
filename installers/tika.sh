#!/bin/bash
# Install Tika & Teseract
LINE="-----------------------------------------------------------"

echo "Installing Debian dependencies"
sudo apt-get install default-jdk maven unzip
echo $LINE
sleep 1

echo "Getting Tika source code"
mkdir install
curl https://codeload.github.com/apache/tika/zip/trunk -o trunk.zip
unzip trunk.zip
echo $LINE
sleep 1

echo "Installing Tika" 
cd tika-trunk
mvn -DskipTests=true clean install
cp tika-server/target/tika-server-1.*-SNAPSHOT.jar /srv/tika-server-1.*-SNAPSHOT.jar
echo $LINE
sleep 1

echo "Installing Tesseract via Debian"
sudo apt-get -y -q install tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng
sleep 1

echo "Cleaning Up"
rm trunk.zip
sleep 1

echo "All done. Hooray!"
