require 'optparse'
require 'curb'
require 'json'

class DocIndexer

	def initialize(options, argv)
		@path = options.path
		@type = options.type
		@index = options.index
	end

	def run
		puts "DocIndexer is starting..."
		Dir[@path + "*"].each do |file|
		  json = JSON.pretty_generate(JSON.parse(File.read(file)))
		  c = Curl::Easy.new("http://localhost:3000/add_items")
		  c.http_post(Curl::PostField.content("item_type", @type),
					  Curl::PostField.content("index_name", @index),
					  Curl::PostField.content("items", json))
		end
		puts "Indexing is complete!"
	end
end

options = OpenStruct.new                                                        
OptionParser.new do |opt|                                                       
  opt.on('-p', '--path /home/user/data/', 'Path to your data') { |o| options.path = o }
  opt.on('-t', '--type LegalDocs', 'Item type') { |o| options.type = o }
  opt.on('-i', '--index free_press_legal', 'Name of index for this data') { |o| options.index = o }
end.parse!                                                                      
                                                                                                                                                               
loadfile = DocIndexer.new(options, ARGV)                                      
loadfile.run()
