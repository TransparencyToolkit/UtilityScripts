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

	puts "Use Tika instance: " + @tika

    # Runs as "@process_block" in DirCrawl
    parsefile = lambda do |file, dir, output_dir, tika|
      p = ParseFile.new(file, dir, output_dir, tika)
      p.parse_file
    end

    include = lambda do
		require 'parsefile'
    end
	
  	path_params = {
		path: @dir,
		output_dir: "#{@dir}_output",
		ignore_includes: "_terms",
		failure_mode: "log"
	}

	cm_hash = nil
	extras = lambda do |output_dir|
	end

	puts "Saving to: " + path_params[:output_dir]

    d = DirCrawl.new(path_params, parsefile, include, extras, cm_hash, path_params[:path], path_params[:output_dir], @tika)
  end
end


# Arguments
options = OpenStruct.new
OptionParser.new do |opt|
  opt.on('-t', '--tika TIKA', 'Use a local Tika server') { |o| options.tika = o }
end.parse!

puts "KeepGrabbing: documents"

loadfile = GrabLoadFile.new(options, ARGV)
loadfile.run()
