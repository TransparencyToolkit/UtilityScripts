require 'json'
require 'nokogiri'
require 'pry'

class PicFixSave
  def initialize(input_dir, output_dir)
    @input_dir = input_dir
    @output_dir = output_dir
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
    f_with_tools= JSON.parse(f)
    
    outarr = Array.new
    f_with_tools.each do |item|
      itemhash = item
      if itemhash["picture"] == nil
        itemhash["picture"] = picture(Nokogiri::HTML(item["full_html"]))
        itemhash["pic_path"] = pic_path(Nokogiri::HTML(item["full_html"]))
      end
      outarr.push(itemhash)
    end

    delete_duplicate_pics
    return JSON.pretty_generate(outarr)
  end

    # Get path to the picture url
    def picture(html)
      pic = html.css('.profile-picture').css('img').first
      if pic
        pic_url = pic['src'] ? pic['src'] : pic['data-delayed-url']
        return pic_url
      end
    end

    # Download picture
    def pic_path(html)
      if picture(html)
        # Get path
        dir = "pictures/"
        full_path = dir+picture(html).split("/").last.chomp.strip

        # Get file
        `wget -P #{dir} #{picture(html)}` if !File.file?(full_path)
        return full_path
      end
    end

    # Deletes duplicate pictures
    def delete_duplicate_pics
      pics = Dir["pictures/*.jpg.*"]
      pics.each do |p|
        File.delete(p)
      end
    end
end

p = PicFixSave.new("/home/shidash/Data/version_error", "/home/shidash/Data/processed_version_error2")
p.process_each_file("/home/shidash/Data/version_error")
