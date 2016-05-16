require 'parsefile'
require 'dircrawl'

class GrabLoadFile

  def initialize(dir)
    print "Loading directory: " + dir + "\n"
    @dir = dir
  end

  # Load in docs
  def run
    # Make blocks for dircrawl
    block = lambda do |file, in_dir, out_dir|
      p = ParseFile.new(file, in_dir, out_dir)
      p.parse_file
    end

    include = lambda do
      require 'parsefile'
    end

    # Call dircrawl
    out_dir = @dir+"_output"
	#binding.pry
    d = DirCrawl.new(@dir, out_dir, "_terms", false, block, include, @dir, out_dir)
    JSON.parse(d.get_output)
  end

end

puts "Grabbing some documents...."

loadfile = GrabLoadFile.new(ARGV[0])
loadfile.run()
