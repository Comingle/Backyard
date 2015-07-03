require 'json'
require 'erb'
require 'securerandom'
require 'fileutils'
require 'digest'
require 'open3'

SKETCHDIR = Rails.root + "sketches"
CATEGORIES = ["general", "pattern", "nunchuck"]
IGNORE = ["hid"]

INO = "/usr/local/bin/ino"
TARGET = "LilyPadUSB"
TARGETNOHID = "LilyPadUSBnoHID"
AVROBJCOPY = "/usr/bin/avr-objcopy"
AVROBJCOPYOPTS = "-I ihex -O binary"
GENERAL = ["model", "serial_console", "click", "doubleclick", "longpressstart", "time_scale", "power_scale"]

class Sketch < ActiveRecord::Base
  class BuildError < StandardError
    def initialize(message = nil, action = nil, subject = nil)
      @message = message
      @action = action
      @subject = subject
      @default_message = I18n.t(:"unauthorized.default", :default => "There was an error building your sketch.")
    end

    def to_s
      @message || @default_message
    end
  end

  serialize :config, JSON

  has_many :options
  has_many :toys
  has_many :components, :through => :options
  #has_many :components, :through => :patterns
  has_many :users, :through => :toys
  has_many :sketch_histories
  # has_many :patterns, :inverse_of => :sketch
  accepts_nested_attributes_for :options
  #accepts_nested_attributes_for :patterns

  after_validation :get_build_dir
  #before_save :build_sketch
  #before_update :build_sketch

  def compile
    props = build_sketch
    old = Sketch.where("size = ? AND sha256 = ?", props.size, props.sha256)
    if (old.empty?)
      self.save!
    else
      clean_build_dir
    end
  end
  

  ## Fetch all components, join them together, process ERB substitutions
  ## Returns compilable Arduino code
  def create_sketch
    # XXX -- add nunchuck header selection
    header = Component.find_by_name_and_category("header", "general")
    footer = Component.find_by_name_and_category("footer", "general")

    template_list = Array.new
    template_list.push(return_segments(header))
    # Config keys are the top-level JSON hashes. We use those as categories
    # for gathering components
    config.keys.each do |c|
      template_list.push(gather_components(c))
    end
    template_list.push(return_segments(footer))
    template_list.flatten!

    global = template_list.map { |g| g[:global] }.join("")
    setup = template_list.map { |g| g[:setup] }.join("")
    loop = template_list.map { |g| g[:loop] }.join("")

    sketch = [global, setup, loop].join("\n")
    sketchfile = get_sketch_file
    File.open sketchfile, "w" do |file|
        file << sketch
    end
    configfile = get_src_dir + "config.json"
    File.open configfile, "w" do |file|
      file << self.as_json(:only => GENERAL)
      file << self.config
    end
  end
  
  def gather_components(category)
    component_list = Array.new
    config = self.config[category]

    # Throw out false values
    config.keys.reject {|i| self[i].class == FalseClass}.each do |comp_name|
      next if comp_name.match("startup_sequence")

      # Make sure our corresponding component actually exists. 
      # Very bad if not..
      comp_template = Component.find_by_name_and_category(comp_name, category)
      next if !comp_template
      
      # If our particular item is a hash or array, we assume it has
      # nested attributes.
      if config[comp_name].class == Hash || config[comp_name].class == Array
        context = config[comp_name]
      else
        context = config
        # Find if our value is a blob referring to another component
        component = Component.find_by_name_and_category(config[comp_name], "blob")
        if !component.nil?
          context = {comp_name => component.global}
        end
      end
      component_list.push(return_segments(comp_template, context))
    end
    # Special case for this one for now
    seq = context = nil
    startup_seq = config['startup_sequence']
    if startup_seq
      if startup_seq.class == TrueClass
        seq = Component.find_by_name("startup_sequence")
      elsif startup_seq.class == String && startup_seq.match("startup_sequence")
        seq = Component.find_by_name("startup_sequence")
      elsif Component.find_by_name(startup_seq)
        if Component.find_by_name(startup_seq).category == "pattern"
          seq = Component.find_by_name("startup_pattern")
          context = self.startup_sequence
      # TODO: if we're running a pattern at startup make sure the pattern
      # itself is actually included.
        end
      end
      component_list.push(return_segments(seq, context))
    end
    component_list
  end

  def get_sketch_file
    get_src_dir + "sketch.ino"
  end

  def get_src_dir
    get_build_dir + "src"
  end

  def get_build_dir
    if (!Dir.exists?(SKETCHDIR))
      Dir.mkdir SKETCHDIR
    end
    if (!self.build_dir)
      token = get_token
      dir = SKETCHDIR + token
      while (Dir.exists?(dir))
        token = get_token
        dir = SKETCHDIR + token
      end
      Dir.mkdir dir
      src = dir + "src"
      Dir.mkdir src
      self.build_dir = dir
    end
    Pathname.new(self.build_dir)
  end

  def get_target
    if self.hid
      TARGET
    else
      TARGETNOHID
    end
  end

  def get_hex_data
    build_dir = get_build_dir
    target = get_target
    path = build_dir + ".build" + target + "firmware.hex"
    if File.exists?(path)
      File.open(path, "r") { |f|
        f.read
      }
    end
  end

  def clean_build_dir
    origdir = Dir.getwd
    Dir.chdir(get_build_dir)
    Open3.capture2(INO, "clean")
    Dir.chdir(origdir)
  end

  def build_sketch
    create_sketch
    origdir = Dir.getwd
    Dir.chdir(get_build_dir)
    clean_build_dir
    if (self.hid)
      target = TARGET
    else
      target = TARGETNOHID
    end
    objdir = get_build_dir + ".build" + target
    stdout, stderr, status = Open3.capture3(INO + " build -m " + target)
    if status.success?
      @hex = objdir + "firmware.hex"
      @bin = objdir + "firmware.bin"
      stdout, stderr, status = Open3.capture3(AVROBJCOPY + " " + AVROBJCOPYOPTS + " #{@hex} #{@bin}")
      if status.success?
        self.sha256 = Digest::SHA256.file @bin
        self.size = File.size? @bin
      else
        puts "avr-objcopy failed: #{stderr}"
        raise BuildError.new(message: "avr-objcopy failed: #{stderr}")
      end
    else
      puts "Build failed: #{stderr}"
      raise BuildError.new(message: "Build failed: #{stderr}")
    end
    Dir.chdir(origdir)
    {:size => self.size, :sha256 => self.sha256}
  end

  def read_config
    config_options = JSON.parse(self.config)
    config_options['toy']
  end

  def get_token
    date = Time.now.strftime("%Y-%m-%d")
    token = "#{date}-" + SecureRandom.hex(6)
    token
  end

  def self.find_by_hex(hex)
    hex.gsub(/[^:0123456789ABCDEFabcdef]/,"")
    hex = hex[0..90000]
    hexfile = Tempfile.new(['firmware', '.hex'])
    hexfile.write(hex)
    hexfile.flush
    binfile = Tempfile.new(['firmware', '.bin'])
    sketch = Sketch.new

    stdout, stderr, status = Open3.capture3("#{AVROBJCOPY} #{AVROBJCOPYOPTS} #{hexfile.path} #{binfile.path}")

    if status.success?
      binary = File.open(binfile.path, "rb") { |file|
        file.read
      }
      Sketch.where("size is not null and sha256 is not null").each do |s|
        if (Digest::SHA256.new.update(binary[0 .. (s.size-1)]) == s.sha256)
          sketch = Sketch.find(s.id)
        end
      end
    end

    hexfile.close
    hexfile.unlink
    binfile.close
    binfile.unlink

    sketch
  end

  # Return global, local, setup sections of a component. Context is used to
  # provide ERB substitutions
  private
    def return_segments(component, context = nil)
      global = Erubis::Eruby.new(component.global).result(context)
      setup = Erubis::Eruby.new(component.setup).result(context)
      loop = Erubis::Eruby.new(component.loop).result(context)
      {:global => global, :setup => setup, :loop => loop}
    end

end
