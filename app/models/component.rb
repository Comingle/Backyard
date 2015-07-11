require 'open3'

GCC = "/usr/bin/gcc"
AVRGCC = "/usr/bin/avr-gcc"
GCCARGS = "-lm -o"
PATTERNDIR = Rails.root + "patterns"
PATTERNTEMPLATE = PATTERNDIR + "c_pattern_template.erb"
ERBITEMPAIR = /%=\s*(?:defined\?\()?(\w*)(?:\))?\s*\?.*:\s*(\S+)\s*%>/
ERBITEMNAME = /%=\s*(?:defined\?\()?(\w*)(?:\))?\s*\?.*:\s*\S+\s*%>/
ERBITEMDEFINED = /defined\?\((\w*)\)/
ERBITEMCALLED = /\#\{(\w*)\}/

class Component < ActiveRecord::Base
  
  #has_many :options
  has_many :sketches, :through => :options
  #has_many :patterns, :inverse_of => :component
  has_many :options, :inverse_of => :component

  # after_validation :build_pattern, if: :is_pattern?

  scope :patterns, lambda { where(:category => "pattern") }

  def is_pattern?
    category.match("^pattern$")
  end

  def test_pattern(opts = {}, num_steps = period)
    return if !is_pattern?

    # Set up default values for pattern, substituting optional supplied vals
    defaults = pat_options
    defaults.each do |i|
      max = i[:max]
      min = i[:min]
      item = i[:name].to_sym
      default_value = i[:default]
      if opts[item].nil? 
        opts[item] = default_value 
      elsif (opts[item] > max) || (opts[item] < min)
        opts[item] = default_value 
      end
    end

    # Replace given pattern name with generic name
    # Setup build dir
    new_pat = global.gsub(/int\s+\w+\s*\(int seq\)/, "int pattern(int seq)")
    pattern_build_dir = PATTERNDIR + name
    c_prog = Tempfile.new(name) 
    c_file = Tempfile.new([name, ".c"])
    if (!Dir.exists?(pattern_build_dir))
      Dir.mkdir pattern_build_dir
    end

    # Substitute ERB variables and write to file
    pattern_template = Erubis::Eruby.new(File.read(PATTERNTEMPLATE)).result(new_pat.send(:binding))
    c_pattern = Erubis::Eruby.new(pattern_template).result(opts)
    File.open c_file, "w" do |file|
      file << c_pattern
    end
    c_file.close
    c_prog.close

    # Compile first with avr-gcc to prevent non-AVR functions (setuid()...) from slipping past us. If that's fine, then compile with gcc for local exec. Probably some way around this..
    steps = Hash.new
    stdout, stderr, status = Open3.capture3("#{AVRGCC} #{c_file.path} #{GCCARGS} #{c_prog.path}")
    if status.success?
      stdout, stderr, status = Open3.capture3("#{GCC} #{c_file.path} #{GCCARGS} #{c_prog.path}")
      if status.success?
        steps, steperr, stepstatus = Open3.capture3("#{c_prog.path} #{num_steps}")
      else
        steps['error'] = stderr
      end
    else
      steps['error'] = stderr
    end
    c_file.unlink
    c_prog.unlink
    steps.class == Hash ? steps : JSON.parse(steps)
  end

  # returns variable name and default value
  def pat_options
    if !is_pattern? 
      return nil
    end
    opts_with_vals = Array.new
    # global portion of pattern is where the action is. no substitutions
    # should be happening in setup or loop.
    options = global.scan(ERBITEMPAIR)

    # Each 'o' is a [variable name, default value] array
    options.each do |o|
      v = Variable.find_by_name(o[0])
      opts_with_vals.push({
        name: o[0], 
        default: o[1], 
        min: v.min ? v.min : 0,
        max: v.max ? v.max : 255,
        description: v.description
      })
    end
    opts_with_vals
  end

  # Fetch all ERB variable substitutions, but ignore those also 
  # defined within the component itself
  def variables
    joined = [global,setup,loop].join("\n")
    defined = joined.scan(ERBITEMNAME).flatten.uniq.reject { |i|
      !joined.scan(/<%\s*(#{i})\s*=/).empty?
    }
    called = joined.scan(ERBITEMCALLED).flatten.uniq.reject { |i|
      !joined.scan(/<%\s*(#{i})\s*=/).empty?
    }
    defined.push(called).flatten
  end

  def variable_objs
    objs = Array.new
    variables.each do |v|
      objs.push(Variable.where("name = ?", v).first_or_create do |var|
        var.name = v
      end)
    end
    objs.empty? ? nil : objs
    #Variable.where.any_of(*names.each_with_index { |v,i|
    #  names[i] = {"name" => v}
    #})
  end

end
