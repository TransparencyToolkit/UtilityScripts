require 'json'
require 'termextractor'

puts "List of terms to extract: "
extractlist = gets.strip
extract = File.read(extractlist)

puts "Dir to extract from: "
extractdir = gets.strip

outarr = Array.new
Dir.foreach(extractdir) do |file|
  if file.include?(".json")
    e = TermExtractor.new(File.read(extractdir+"/"+file), ["description", "title",  "headquarters", "address", "skills", "location", "area", "company"], "extracted")
    e.extractSetTerms(extract, ["Search Terms"], "case-insensitive")
    out = JSON.parse(e.getOnlyMatching)
    out.each do |i|
      i[:file_name] = file
      outarr.push(i)
    end
  end
end

File.write(extractdir+"_match_terms.json", JSON.pretty_generate(outarr))
File.write(extractdir+"_match_terms.csv", `json2csv '#{extractdir+"_match_terms.json"}'`)


