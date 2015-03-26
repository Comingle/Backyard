class Toy < ActiveRecord::Base
  belongs_to :sketch
  belongs_to :user
end
