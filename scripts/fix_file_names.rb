require 'pry'

class FixFileNames
  def initialize(path, output_dir)
    @path = path
    @output_dir = output_dir
  end

  # Change the names
  def fix_names
    Dir.foreach(@path) do |file|
      next if file == '.' or file == '..'
      fixed_name = file.gsub("_", "-").gsub("----", "-").gsub("---", "-").gsub("--", "-")

      system("convert #{@path+file} #{@output_dir+fixed_name}")
    end
  end
end

f = FixFileNames.new(ARGV[0], ARGV[1])
f.fix_names
