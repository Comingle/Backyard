class Toy < ActiveRecord::Base
  belongs_to :sketch
  belongs_to :user
  has_many :sketch_histories
end
