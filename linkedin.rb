require 'json'
#require 'linkedincrawler'
load "/home/shidash/Code/LinkedinCrawler/lib/linkedincrawler.rb"
require 'fileutils'
#require 'json2csv'

log = Array.new
# Logs stats about search term run
def log_stats(scrapeout, term, start_time)
  end_time = Time.now
  runtime = end_time - start_time
  log.push(runtime: runtime, start_time: start_time, end_time: end_time, term: term, length: JSON.parse(scrapeout).length)
end


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

puts "CAPTCHA solving key:"
captcha_key = gets.strip

# Go through all terms and scrape
file.each do |term|
  `rm -r /tmp/webdriver*`
  if !File.exist?(resultsdir+"/"+term["Search Term"].gsub(" ", "_").gsub("/", "-")+".json")
    start_time = Time.now
    begin
      # Run term
      requests_linkedin = RequestManager.new(proxy_list, [1, 2], 5)
      requests_google = RequestManager.new(proxy_list, [1, 3], 1)
      requests_google2 = RequestManager.new(proxy_list, [1, 3], 1)
      
      c = LinkedinCrawler.new(term["Search Term"], 1, requests_linkedin, requests_google, requests_google2, {captcha_key: captcha_key})
      c.search
      scrapeout =  c.gen_json
      
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


#File.write(resultsdir+"/log.txt", JSON.pretty_generate(log))

# Move the pictures directory to the results folder
if !Dir.exist?(resultsdir+"/pictures")
  `mv public #{resultsdir}/pictures`
else
  `cp pictures/* #{resultsdir}/pictures`
   `rm -r public `
end

