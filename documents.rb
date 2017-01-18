require 'optparse'
require 'ostruct'
require 'dircrawl'
require 'parsefile'

class GrabLoadFile

  def initialize(options, argv)
	if argv[0]
      puts "Loading directory: " + argv[0]
      @dir = argv[0]
	  @tika = options.tika
	end
  end

  # Load in docs
  def run

	puts "Using tika value"
	puts @tika

    # Make blocks for dircrawl
    block = lambda do |file, in_dir, out_dir, tika|
      p = ParseFile.new(file, in_dir, out_dir, tika)
      p.parse_file
    end

    include = lambda do
		require 'parsefile'
    end

    # Call dircrawl
    # TODO: check for trailing slash
    out_dir = @dir+"_output"

	# Create folder for attachments
	extras = lambda do |out_dir|
	end

	puts "- getting docs from: " + @dir
	puts "- saving to: " + out_dir

    d = DirCrawl.new(@dir, out_dir, "_terms", false, block, include, extras, @dir, nil, out_dir, @tika)
    JSON.parse(d.get_output)
  end

end


# Arguments
options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-t', '--tika TIKA', 'Use a local Tika server') { |o| options.tika = o }
end.parse!

puts "KeepGrabbing documents"

loadfile = GrabLoadFile.new(options, ARGV)
loadfile.run()
