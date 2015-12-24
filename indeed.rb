require 'json'
require 'indeedcrawler'
require 'fileutils'


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
  `rm -r /tmp/webdriver*`
  if !File.exist?(resultsdir+"/"+term["Search Term"].gsub(" ", "_").gsub("/", "-")+".json")
    begin
      # Run term
      i = IndeedCrawler.new(term["Search Term"], term["Location"], proxy_list, [0.2, 0.3], 5)
      scrapeout = i.collect_it_all
      
      # Write to file
      filename = resultsdir+"/"+term["Search Term"].gsub(" ", "_").gsub("/", "-")+".json"
      File.write(filename, scrapeout)

      # Log performance
#      log_stats(scrapeout, term["Search Term"], start_time)
    rescue => error
 #     File.write(term["Search Term"].gsub(" ", "_")+".errors", error)
    end
  end
end

