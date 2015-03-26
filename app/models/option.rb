class Option < ActiveRecord::Base
  belongs_to :component
  belongs_to :sketch

end
