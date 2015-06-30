class Option < ActiveRecord::Base
  validates :sketch, :presence => true
  validates :component, :presence => true
  belongs_to :component
  belongs_to :sketch

  serialize :kv, JSON
end
