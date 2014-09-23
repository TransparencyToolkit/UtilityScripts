require 'json'

class JsonGen
  def initialize
    print "Filename: " 
    @filename = gets.chomp
    @content = File.exist?(@filename)? JSON.parse(File.read(@filename)) : ""
    @structure = Array.new
  end

  # Run generate if file does not exist, add if it does
  def run
    if @content.empty?
      generate
      @content = Array.new
      add
    else
      getSchema
      add
    end
    
    File.write(@filename, JSON.pretty_generate(@content))
  end

  # Generate structure
  def generate
    print "Add Field Name: "
    field = gets.chomp

    # Add field and call generate agan
    unless field.empty?
      @structure.push(field)
      generate
    end
  end

  # Adds item to JSON
  def add
    itemhash = Hash.new
    flag = 0
    puts ""

    # Add items and track if there is an empty value
    @structure.each do |i|
      print i+": "
      value = gets.chomp
      flag = 1 if !value.empty? || flag == 1
      itemhash[i] = value
    end

    # Save and rerun if not empty
    @content.push(itemhash) if flag == 1
    add if flag == 1
  end

  # Gets the schema from the first item of a JSON
  def getSchema
    @content[0].each do |k, v|
      @structure.push(k)
    end
  end
end

j = JsonGen.new
j.run
