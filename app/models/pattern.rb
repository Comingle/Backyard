class Pattern < ActiveRecord::Base
  validates :sketch, :presence => true
  validates :component, :presence => true
  belongs_to :sketch
  belongs_to :component
end
