#!/bin/bash
# Install Tika & Teseract
LINE="-----------------------------------------------------------"

TIKA_VER="1.15"
TIKA_ZIP="tika-1.15.zip"

echo "Installing Tesseract via Debian"
sudo apt-get -y -q install tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng
sleep 2

echo "Installing Tika dependencies via Debian"
sudo apt-get install default-jdk maven unzip
echo $LINE
sleep 2

echo "Getting Tika source code"
curl -L https://github.com/apache/tika/archive/${TIKA_VER}.zip -o $TT_APPS/${TIKA_ZIP}
unzip $TT_APPS/${TIKA_ZIP} -d $TT_APPS/
rm $TT_APPS/${TIKA_ZIP}
echo $LINE
sleep 2

echo "Installing Tika" 
cd $TT_APPS/tika-${TIKA_VER}/
mvn -DskipTests=true clean install

echo "Copying Tika binary"
echo sudo cp $TT_APPS/tika-${TIKA_VER}/tika-server/target/tika-server-${TIKA_VER}.jar /srv/tika-server-${TIKA_VER}.jar
ls -l /srv/tika-server-${TIKA_VER}-SNAPSHOT.jar
echo $LINE
sleep 2

echo "Done installing Tika & Tesseract. Hooray!"
