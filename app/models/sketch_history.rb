class SketchHistory < ActiveRecord::Base
  belongs_to :toy
  belongs_to :sketch
end
