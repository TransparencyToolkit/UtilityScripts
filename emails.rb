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
 
    # Make blocks for dircrawl
    block = lambda do |file, in_dir, out_dir|
      p = Emailparser.new(file, out_dir, "attachments/")
      p.parse_message
    end

    include = lambda do
		require 'emailparser'
	 end

    # Call dircrawl
    out_dir = @dir+"_output"

	# Create folder for attachments
	extras = lambda do |out_dir|
	  puts "created attachment directory"
      Dir.mkdir(out_dir + "attachments") if !Dir.exist?(out_dir + "attachments")
	end

    d = DirCrawl.new(@dir, out_dir, "_terms", false, block, include, extras, @dir, out_dir)
    JSON.parse(d.get_output)
  end

end

puts "Grabbing some emails...."

loadfile = GrabLoadEmail.new(ARGV[0])
loadfile.run()
