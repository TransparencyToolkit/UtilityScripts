require 'json'
require 'pry'

class AddField
  def initialize
    print "Enter File to Add Field To: "
    @filename = gets.chomp
    @file = JSON.parse(File.read(@filename))
    @output = Array.new
    add_field
  end

  # Get field name to add
  def add_field
    print "Enter Field to Add: "
    @field_name = gets.chomp
  end

  # Fill in field for each item
  def fill_val
    @file.each do |item|
      puts item
      print @field_name+": "
      item[@field_name] = gets.chomp
      @output.push(item)
    end
    File.write(@filename, JSON.pretty_generate(@output))
  end
end
a = AddField.new
a.fill_val
