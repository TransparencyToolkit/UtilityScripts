KeepGrabbing
============

This is a collection of scripts for managing scrapers

**Summary**

- `jsongen.rb` Generates JSONs using a schema you specify. Can be used for 
anything, but it's good for making machine-readable lists of search terms
- `linkedin.rb` Runs the LinkedIn scraper on a set of search terms in a json
- `crypto` Encrypt and decrypt all files in a directory with GPG
- `config` Scripts for setup and syncing a scraping machine

### Detailed Instructions

1. Run `ruby jsongen.rb`

Currently this only supports single level JSONs.

To Run:

1. Run `ruby json.rb`
2. Follow the directions to manually input the schema and items
3. Stop adding items by adding an item with all blank fields

linkedin.rb

To run this, you need a JSON where every item has the following fields:
Search Term: The phrase you want to search for
Degrees: The number of degrees you want to go out with "people also viewed"

To Run:

1. Run `ruby linkedin.rb`
2. When prompted, type in the name of the file with the search terms
3. When prompted, type in the name of the directory where you want to save
results
4. Wait. A new .json and .csv file will be generated for each search term


crypto/-
Encrypt files with encrypt.rb and decrypt with decrypt.rb.

---

### Encrypt & Decrypting Files

**Encrypting**

1. Run `ruby encrypt.rb`
2. When prompted, type the email address of recipient (keys must be imported
into GPG already). You can add as many recipients as you want
3. Hit enter, leaving a recipient blank, when you want to stop adding
recipients
4. When prompted, enter the path to the directory where you want to save
results
5. Wait as the files are encrypted

**Decrypting**

1. Run `ruby decrypt.rb`
2. When prompted, enter the path to the directory where you want to decrypt
files.
3. Enter the password for your GPG key
4. Wait as the files are decrypted

---


config/-
Setup and syncing scripts for a scraping machine

Setup:
./install.sh

Sync:
./sync.sh

---


### Documents

1. Install system dependencies for Debian

```
sudo apt-get install build-essential pkg-config curl libcurl3 libcurl3-gnutls 
libcurl4-openssl-dev rmagic libmagickwand-dev imagemagick graphicsmagick 
poppler-utils poppler-data ghostscript tesseract-ocr pdftk libreoffice
```

2. Install Ruby dependencies `bundle install` from in the directory
3. Run the document converter script

```
ruby documents.rb path/to/files/
```

### Emails

1. Run email converter script with

```
ruby emails.rb --tika=http://localhost:9998 /full/path/to/your/documents
```

