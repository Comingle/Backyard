require 'json'
require 'erb'
require 'securerandom'
require 'fileutils'
require 'digest'
require 'open3'

SKETCHDIR = Rails.root + "sketches"
CATEGORIES = ["general", "pattern"]

INO = "/usr/local/bin/ino"
TARGET = "LilyPadUSB"
TARGETNOHID = "LilyPadUSBnoHID"
AVROBJCOPY = "/usr/bin/avr-objcopy"
AVROBJCOPYOPTS = "-I ihex -O binary"

class Sketch < ActiveRecord::Base

  has_many :options
  has_many :toys
  has_many :components, :through => :options
  has_many :users, :through => :toys
  has_many :sketch_histories

  ## Fetch all components, join them together, process ERB substitutions
  ## Returns compilable Arduino code
  def create_sketch
    header = Component.find_by_name('header')
    component_list = Array.new
    ["header", "id", "click", "doubleclick", "longpressstart"].each do |i|
      component_list.push(Component.find_by_name(i))
    end
    toy = read_config
    self.model = toy['id']
    self.hid = toy['hid'].class == TrueClass ? true : false
    self.serial_console = toy['serial_console'] == FalseClass ? false : true
    self.startup_sequence = toy['startup_sequence']
    self.click = toy['click']
    self.doubleclick = toy['doubleclick']
    self.longpressstart = toy['longpressstart']
    component_list.push(parse_config(toy, "pattern"))
    ["startup_sequence", "footer"].each do |i|
      component_list.push(Component.find_by_name(i))
    end
    component_list.flatten!
    global = component_list.map { |g| g.global }.join("")
    setup = component_list.map { |g| g.setup }.join("")
    loop = component_list.map { |g| g.loop }.join("")
    sketch_template = ERB.new([global, setup, loop].join("\n"))
    @sketch = sketch_template.result(toy.send(:binding))
    puts @sketch
    sketchfile = get_src_dir + "sketch.ino"
    File.open sketchfile, "w" do |file|
        file << @sketch
    end
    configfile = get_src_dir + "config.json"
    File.open configfile, "w" do |file|
      file << self.config
    end
  end

  def patterns
    names = read_config['pattern'].keys
    plist = Array.new
    names.each do |n|
      plist.push(Component.find_by_name_and_category(n, "pattern"))
    end
    plist
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
      self.save!
    end
    Pathname.new(self.build_dir)
  end

  def clean_build_dir
    origdir = Dir.getwd
    Dir.chdir(get_build_dir)
    Open3.capture2(INO, "clean")
    Dir.chdir(origdir)
  end

  def build_sketch
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
        if (!Sketch.where("size = ? AND sha256 = ?", self.size, self.sha256))
          self.save!
        end
      else
        puts "avr-objcopy failed: #{stderr}"
      end
    else
      puts "Build failed: #{stderr}"
    end
    Dir.chdir(origdir)
  end

  def read_config
    config_options = JSON.parse(self.config)
    config_options['toy']
  end

# Traverse the configuration hash and fetch the global, local and setup segments
# for each component. Will recurse in to directions named in TRAVERSE
  def parse_config(item, category)
    list = Array.new
    item.keys.each do |o|
      next if (!item[o])
      if (CATEGORIES.index(o))
        list.push(parse_config(item[o], o))
      else
        if (item[o].class != FalseClass)
          component = o
        elsif (item[o].class == Array)
          component = item[o]
        elsif (item[o].class = Hash)
          component = o
        end
        if create_option(Component.find_by_name_and_category(o, category), item[o])
          list.push(Component.where({name: component, category: category}))
          puts component
        end

      end
    end
    list
  end

  def get_token
    date = Time.now.strftime("%Y-%m-%d")
    token = "#{date}-" + SecureRandom.hex(6)
    token
  end

  def create_option(component, setting)
    if !Option.find_by(sketch_id: self.id, component_id: component.id)
      if (setting.class == Hash)
        if setting.empty?
          Option.new(sketch_id: self.id, component_name: component.name,
          component_id: component.id).save!
        else
          setting.each do |k,v|
            Option.new(sketch_id: self.id, component_name: component.name,
            component_id: component.id, key: k.to_s, value: v.to_s).save!
          end
        end
      elsif setting.class == Array
        setting.each_with_index do |v,i|
          Option.new(sketch_id: self.id, component_name: component.name,
          component_id: component.id, key: i.to_s, value: v.to_s).save!
        end
      else
        Option.new(sketch_id: self.id, component_name: component.name,
        component_id: component.id, key: component.name, value: setting.to_s).save!
      end
    end
  end


  def self.find_by_hex(hex)
    hex = hex[0..90000]
    hexfile = Tempfile.new(['firmware', '.hex'])
    hexfile.write(hex)
    hexfile.flush
    binfile = Tempfile.new(['firmware', '.bin'])

    stdout, stderr, status = Open3.capture3("#{AVROBJCOPY} #{AVROBJCOPYOPTS} #{hexfile.path} #{binfile.path}")

    if status.success?
      binary = File.open(binfile.path, "rb") { |file|
        file.read
      }

      sketch = nil
      Sketch.where("size is not null and sha256 is not null").each do |s|
        if (Digest::SHA256.new.update(binary[0 .. (s.size-1)]) == s.sha256)
          sketch = Sketch.find(s.id)
        end
      end

      hexfile.close
      hexfile.unlink
      binfile.close
      binfile.unlink

      sketch
    else
      nil
    end
  end
end
