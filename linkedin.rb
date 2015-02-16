require 'json'
require 'linkedindata'
require 'fileutils'
require 'json2csv'

# Read JSON with search terms
puts "Where is the list of terms to scrape?"
scrapelist = gets.strip
file = JSON.parse(File.read(scrapelist))

# Create results dir
puts "Where should results be saved?"
resultsdir = gets.strip
unless File.directory?(resultsdir)
  Dir.mkdir(resultsdir)
end

# Go through all terms and scrape
file.each do |term|
  l = LinkedinData.new(term["Search Term"], term["Degrees"].to_i)
  scrapeout = l.getData
  filename = resultsdir+"/"+term["Search Term"].gsub(" ", "_").gsub("/", "-")+".json"
  File.write(filename, scrapeout)
  File.write(filename.gsub(".json", ".csv"), `json2csv #{filename}`)
end

# Move the pictures directory to the results folder
`mvdir public #{resultsdir/public}`


