class Nunchuck < ActiveRecord::Base
  belongs_to :user

  serialize :config, JSON

end
