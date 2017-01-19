require 'emailparser'
require 'dircrawl'
require 'pry'

class GrabLoadEmail

  def initialize(dir)
    print "Loading directory: " + dir + "\n"
    @dir = dir
  end

  # Load in docs
  def run

    # Gets run as "@process_block" in DirCrawl
    emailparser = lambda do |file, in_dir, out_dir|
      p = EmailParser.new(file, out_dir, "attachments/")
      p.parse_message
    end

    include = lambda do
      require 'emailparser'
    end

    # Where files are saved
    out_dir = @dir+"_output"

    # Create folder for attachments
    extras = lambda do |out_dir|
      puts "Created attachment directory"
      Dir.mkdir(out_dir + "attachments") if !Dir.exist?(out_dir + "attachments")
    end

    # Run DirCrawl
    d = DirCrawl.new(@dir, out_dir, "_terms", false, emailparser, include, extras, "log", nil, out_dir)
    JSON.parse(d.get_output)
  end

end

puts "KeepGrabbing: emails"

loadfile = GrabLoadEmail.new(ARGV[0])
loadfile.run()
