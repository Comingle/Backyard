require 'open3'

GCC = "/usr/bin/gcc"
AVRGCC = "/usr/bin/avr-gcc"
GCCARGS = "-lm -o"
PATTERNDIR = Rails.root + "patterns"
PATTERNTEMPLATE = PATTERNDIR + "c_pattern_template.erb"

class Component < ActiveRecord::Base
  
  #has_many :options
  has_many :sketches, :through => :options
  #has_many :patterns, :inverse_of => :component
  has_many :options, :inverse_of => :component

  # after_validation :build_pattern, if: :is_pattern?

  scope :patterns, lambda { where(:category => "pattern") }

  def test_pattern(opts = {}, num_steps = period)
    return if !is_pattern?
    defaults = pat_options
    defaults.each do |i|
      max = i[:max]
      min = i[:min]
      item = i[:name].to_sym
      default_value = i[:default]
      if opts[item].nil? 
        opts[item] = default_value 
      elsif (opts[item] > max) | (opts[item] < min)
        opts[item] = default_value 
      end
    end
    # if num_steps.nil? then num_steps = period end
    new_pat = global.gsub(/int\s+\w+\s*\(int seq\)/, "int pattern(int seq)")
    # new_pat.gsub!(/<%.*:\s*(\d+).*%>/, '\1')
    # if (!Dir.exists?(PATTERNDIR))
    #   Dir.mkdir PATTERNDIR
    #   false
    # end
    pattern_build_dir = PATTERNDIR + name
    # c_prog = pattern_build_dir + name # tmpfile
    c_prog = Tempfile.new(name) 
    c_file = Tempfile.new([name, ".c"])
    # c_file = pattern_build_dir + "#{name}.c" # tmpfile
    if (!Dir.exists?(pattern_build_dir))
      Dir.mkdir pattern_build_dir
    end
    pattern_template = Erubis::Eruby.new(File.read(PATTERNTEMPLATE)).result(new_pat.send(:binding))
    c_pattern = Erubis::Eruby.new(pattern_template).result(opts)
    File.open c_file, "w" do |file|
      file << c_pattern
    end
    # Compile first with avr-gcc to prevent non-AVR functions (setuid()...) from slipping past us. If that's fine, then compile with gcc for local exec. Probably some way around this..
    stdout, stderr, status = Open3.capture3("#{AVRGCC} #{c_file.path} #{GCCARGS} #{c_prog.path}")
    if status.success?
      stdout, stderr, status = Open3.capture3("#{GCC} #{c_file.path} #{GCCARGS} #{c_prog.path}")
      if status.success?
        c_file.close
        c_prog.close
        steps, steperr, stepstatus = Open3.capture3("#{c_prog.path} #{num_steps}")
        # self.testride = c_prog.to_s
      else
        steps = nil
      end
      c_file.unlink
      c_prog.unlink
    end
    steps
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
    # Aww yeah.
    options = global.scan(/%=\s*(?:defined\?\()?(\w*)(?:\))?\s*\?.*:\s*(\S+)\s*%>/)
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
