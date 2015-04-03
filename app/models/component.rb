GCC = "/usr/bin/gcc"
GCCARGS = "-lm -o"
PATTERNDIR = Rails.root + "patterns"
PATTERNTEMPLATE = PATTERNDIR + "c_pattern_template.erb"

class Component < ActiveRecord::Base
  
  has_many :options
  has_many :sketches, :through => :options
  has_many :patterns, :inverse_of => :component

  after_validation :build_pattern, if: :is_pattern?

  scope :patterns, lambda { where(:category => "pattern") }

  def build_pattern
    new_pat = global.gsub(/int\s+\w+\s*\(int seq\)/, "int pattern(int seq)")
    new_pat.gsub!(/<%.*:\s*(\d+).*%>/, '\1')
    if (!Dir.exists?(PATTERNDIR))
      Dir.mkdir PATTERNDIR
      false
    end
    pattern_build_dir = PATTERNDIR + name
    c_prog = pattern_build_dir + name
    c_file = pattern_build_dir + "#{name}.c"
    if (!Dir.exists?(pattern_build_dir))
      Dir.mkdir pattern_build_dir
    end
    pattern_template = ERB.new(File.read(PATTERNTEMPLATE))
    c_pattern = pattern_template.result(new_pat.send(:binding))
    File.open c_file, "w" do |file|
      file << c_pattern
    end
    if (system(GCC + " " + c_file.to_s + " " + GCCARGS + " " + c_prog.to_s))
      self.testride = c_prog.to_s
    end
  end

  def is_pattern?
    category.match("^pattern$")
  end

  # returns variable name and default value
  def pat_options
    if !is_pattern? 
      return nil
    end
    opts_with_vals = Array.new
    options = global.scan(/%=\s*(\S*)\s*\?.*:\s*(\S+)\s*%>/)
    # Each 'o' is a [variable name, default value] array
    options.each do |o|
      if o[0].match("time")
        min = 10
        max = 200
      else
        min = 0
        max = 255
      end
      opts_with_vals.push({name: o[0], default: o[1], min: min, max: max})
    end
    opts_with_vals
  end

end
