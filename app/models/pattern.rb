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

end
