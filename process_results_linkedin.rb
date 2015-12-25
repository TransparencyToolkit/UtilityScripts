require 'json'
require 'extractpatterns'

class ProcessResultsLinkedin
  def initialize(input_dir, output_dir, extract_list, remove_list)
    @input_dir = input_dir
    @output_dir = output_dir

    @remove_list = remove_list
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
      item[:doc_modified] = check_removed(item)
      item[:data_source] = "LinkedIn"
      item[:full_name] = item["name"] if item["name"]
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

  # Check if item was removed
  def check_removed(item)
    removed = JSON.parse(File.read(@remove_list))
    id = item["profile_url"]
   
    # Go through and see if it is in file
    removed.each do |r|
      if r["profile_url"] == id
        # It's in the file, see if it has doc_modified
        if r["doc_modified"]
          return r["doc_modified"]
        end
      end
    end

    return nil
  end

  # Get tools mentioned in item
  def get_tools(file)
    e = ExtractPatterns.new(file, ["description", "summary"], "tools_mentioned")
    return e.search_fields(6, @extract_list, "skills")
  end
end

p = ProcessResultsLinkedin.new("/home/shidash/test_data/li", "/home/shidash/processed_test_data", "/home/shidash/extract_list.json", "/home/shidash/removed_test.json")
p.process_each_file("/home/shidash/test_data/li")
