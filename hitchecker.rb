require 'json'
require 'mechanize'
require 'nokogiri'

class HitChecker
  def initialize(input)
    @input = input
  end

  # Gets the number of results for any search terms
  def numResults(searchterm)
    sleep(rand(20..60))
    agent = Mechanize.new
    agent.user_agent_alias = 'Linux Firefox'
    gform = agent.get("http://google.com").form("f")
    gform.q = searchterm
    page = agent.submit(gform, gform.buttons.first)

    # Get num of results or empty
    results = page.search('#resultStats').text
    resultnum = 0
    if !results.empty?
      num = results.split(" ")
      resultnum = num.length == 3 ? num[1] : num[0] # Handles two result formats
    end

    # Make return hash
    return {
      search_term: searchterm,
      result_num: resultnum,
      result_link: agent.page.uri.to_s
    }
  end

  # Search for exact matches of sentences in text
  def sentenceSearch
    sarray = @input.split(". ")
    matches = Array.new

    # Check for matches for each sentence
    sarray.each do |s|
      results = numResults(preprocess(s))
      matches.push(results) if results[:result_num] != 0
    end

    JSON.pretty_generate(matches)
  end

  # Preprocess sentences
  def preprocess(s)
    processed = s
    
    # Remove footnotes
    if s.scan(/[a-zA-Z]\d+\b/)
      torepl = s.scan(/[a-zA-Z]\d+\b/)
      torepl.each do |i|
        replace = i.to_s.sub(/[a-zA-Z]/, "")
        processed = processed.gsub(replace, "").gsub('\n', '').gsub("- ", "").gsub("-", "")
      end
    end
    
    # Return processed with quotes
    return '"'+processed+'"'
  end

  # TODO:
  # Check combinations of terms
end

Dir.foreach("../../Downloads/") do |f|
  if f.include? ".txt"
    h = HitChecker.new(File.read("../../Downloads/"+f))
    File.write(f.sub(".txt", ".json"), h.sentenceSearch)
  end
end
