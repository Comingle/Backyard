class Pattern < ActiveRecord::Base
  validates :sketch, :presence => true
  validates :component, :presence => true
  belongs_to :sketch
  belongs_to :component

  def name
    self.component.name
  end

  def pretty_name
    self.component.pretty_name
  end

  def description
    self.component.description
  end
 
  # Returns all valid options for a given pattern, its default value
  # and the current setting for that option. If current setting is nil
  # then 'setting' is returned as the default value.
  # Also returns acceptable min/max values for the option
  def options_with_values
    opts_with_vals = Array.new
    # Each pat_option is a 
    # [variable name, default value, minimum value, maximum value] array
    opts = component.pat_options
    opts.each_with_index do |v,i|
      name = v[:name]
      default = v[:default]
      if self[name].nil? then setting = default else setting = self[name] end
      opts[i][:setting] = setting
    end
    opts
  end
    

end
