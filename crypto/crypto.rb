require 'fileutils'
require 'gpgme'
require 'pry'

class Encrypt
  def initialize
    @recipients = Array.new
  end

  # Add keys to the recipients list
  def addKeys
    print "Enter Recipient: "
    key = gets.chomp

    # Add key to recipients args and call again
    unless key.empty?
      @recipients.push(key)
      addKeys
    end
  end

  # Go through all dirs and subdirs
  def dirLoop(dir, action)
    Dir.foreach(dir) do |f|
      next if f == '.' or f == '..'
      if File.directory?(dir+"/"+f)
        dirLoop(dir+"/"+f, action) 
      else
        action == "encrypt" ? encrypt(f, dir) : decrypt(f, dir)
      end
    end
  end


  # Encrypt each file
  def encrypt(file, dir)
    crypto = GPGME::Crypto.new :always_trust => true
    File.open(dir+"/"+file) do |in_file|
      File.open((dir+"/"+file+".gpg"), 'wb') do |out_file|
        crypto.encrypt in_file, :output => out_file, :recipients => @recipients
      end
    end

    File.delete(dir+"/"+file)
  end

  # Decrypt each file
  def decrypt(file, dir)
    if file.include?(".gpg")
      crypto = GPGME::Crypto.new :always_trust => true

      File.open(dir+"/"+file) do |in_file|
        File.open((dir+"/"+file.gsub(".gpg", "")), 'wb') do |out_file|
#          binding.pry
          begin
 #           binding.pry
            crypto.decrypt in_file, :output => out_file
          rescue
            binding.pry
          end
        end
      end
      
     # File.delete(dir+"/"+file)
    end
  end


  # Encrypt all files in a directory
  def encryptAll
    print "Directory to Encrypt: "
    dir = gets.chomp
    dirLoop(dir, "encrypt")
  end

  # Decrypt all files in a directory
  def decryptAll
    print "Directory to Decrypt: "
    dir = gets.chomp
    dirLoop(dir, "decrypt")
  end
end
