require 'json'
require 'extractpatterns'

class ProcessResultsIndeed
  def initialize(input_dir, output_dir, extract_list)
    @input_dir = input_dir
    @output_dir = output_dir

    @extract_list = extract_list
  end

  # Go through each input file and process
  def process_each_file(dir)
    Dir.foreach(dir) do |file|
      next if file == '.' or file == '..'
      if File.directory?(dir+"/"+file)
        process_each_file(dir+"/"+file)
      elsif file.include?(".json")
        create_write_dirs(dir.gsub(@input_dir, @output_dir))
        File.write(get_write_dir(dir, file), process(dir+"/"+file))
      end
    end
  end

  # Figure out where to write it
  def get_write_dir(dir, file)
    dir_save = dir.gsub(@input_dir, @output_dir)
    return dir_save+"/"+file
  end

  # Create if they don't exist
  def create_write_dirs(dir)
    dirs = dir.split("/")
    dirs.delete("")
    overallpath = ""
    dirs.each do |d|
      Dir.mkdir(overallpath+"/"+d) if !File.directory?(overallpath+"/"+d)
      overallpath += ("/"+d)
    end
  end

  # Process file
  def process(file)
    f = File.read(file)
    f_with_tools = get_tools(f)
    
    outarr = Array.new
    f_with_tools.each do |item|
      itemhash = item
      item[:data_source] = "Indeed"
      item[:search_terms] = get_terms(file)
      outarr.push(itemhash)
    end

    return JSON.pretty_generate(outarr)
  end

  # Get search terms
  def get_terms(file)
    f = file.split("/").last
    return f.gsub(".json", "").gsub("_", " ").gsub("-", "/")
  end

  # Get tools mentioned in item
  def get_tools(file)
    e = ExtractPatterns.new(file, ["additional_info", "job_description", "skills", "summary"], "tools_mentioned")
    return e.search_fields(6, @extract_list, nil)
  end
end

p = ProcessResultsIndeed.new("/home/shidash/test_data/indeed", "/home/shidash/processed_test_data_indeed", "/home/shidash/extract_list.json")
p.process_each_file("/home/shidash/test_data/indeed")
