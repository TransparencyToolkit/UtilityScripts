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

puts "Proxy list location:"
proxy_list = gets.strip

# Go through all terms and scrape
file.each do |term|
  if !File.exist?(resultsdir+"/"+term["Search Term"].gsub(" ", "_").gsub("/", "-")+".json")
    l = LinkedinData.new(term["Degrees"].to_i, proxy_list, false, false)
    scrapeout = l.getByKeywords(term["Search Term"])
    filename = resultsdir+"/"+term["Search Term"].gsub(" ", "_").gsub("/", "-")+".json"
    File.write(filename, scrapeout)
    File.write(filename.gsub(".json", ".csv"), `json2csv '#{filename}'`)
  end
end

# Move the pictures directory to the results folder
if !Dir.exist?(resultsdir+"/public")
  `mv public #{resultsdir}/public`
else
  `cp public/uploads/pictures/* #{resultsdir}/public/uploads/pictures`
   `rm -r public `
end

