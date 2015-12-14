require 'requestmanager'
require 'linkedinparser'
require 'fileutils'
require 'pry'
require 'json'

class GrabAgain
  def initialize(input_dir, output_dir, url_field, proxy_list)
    @input_dir = input_dir
    @output_dir = output_dir
    @url_field = url_field
    @proxy_list = proxy_list
    @output = Array.new
  end

  # Loops through all files in dir
  def loop_all_files(dir)
    Dir.foreach(dir) do |file|
      next if file == '.' or file == '..'
      if File.directory?(dir+"/"+file)
        loop_all_files(dir+"/"+file)
      else
        rescrape(file)
      end
    end
  end

  # Gets all the urls in the file
  def get_urls(file)
    results = JSON.parse(File.read(@input_dir+"/"+file))
    @resultslist = Array.new
    results.each do |item|
     @resultslist.push(item[@url_field]) if !@resultslist.include?(item[@url_field])
    end
    return @resultslist
  end

  # Gen the file name
  def gen_filename(file)
    append_name = "_rescrape"+Time.now.to_s.split(" ").first.gsub("-", "")
    return file.gsub(".json", append_name+".json")
  end

  # Get search term from file name
  def get_search_terms(file)
    just_name = file.split("_rescrape").first.gsub(".json", "")
    return just_name.gsub("_", " ").gsub("-", "/")
  end

  # Push search terms for file in output dir
  def array_of_all_output
    @outfiles_done = Array.new
    Dir.foreach(@output_dir) do |file|
      @outfiles_done.push(get_search_terms(file))
    end
    return @outfiles_done
  end

  # Does it meet rescrape conditions-json and not already in output
  def rescrape_conditions_met?(file)
    return file.include?(".json") && !array_of_all_output.include?(get_search_terms(file))
  end

                             
  # Rescrapes all items in file
  def rescrape(file)
    if rescrape_conditions_met?(file)
      urls = get_urls(file)
      
      requests_linkedin = RequestManager.new(@proxy_list, [1, 2], 5)
    
      # Get each page
      urls.each do |url|
        html = requests_linkedin.get_page(url)

        # Parse page
        l = LinkedinParser.new(html, url, {timestamp: Time.now, search_terms: get_search_terms(file)})
        parsed_profile = JSON.parse(l.results_by_job)

        # Write each job to output
        parsed_profile.each do |job|
          @output.push(job)
        end
      end

      puts "NEWDIR: "+ gen_filename(file)
      File.write(@outputdir+"/"+gen_filename(file), JSON.pretty_generate(@output))
      requests_linkedin.close_all_browsers
    end
  end
end

g = GrabAgain.new("/home/shidash/Data/ICWATCH-Data/data/original_run", "/home/shidash/Data/icwatch_rescrape", "profile_url", "/home/shidash/superproxylist")
g.loop_all_files("/home/shidash/Data/ICWATCH-Data/data/original_run")
