class User < ActiveRecord::Base
  has_many :toys
  has_many :sketches, through: :toys
  has_many :nunchucks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  attr_accessor :login

  def authentication_token
    AuthenticationToken.new(hashed_authentication_token)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def generate_authentication_token
    token = SecureRandom.base64(24)
    hashed_token = AuthenticationToken.to_hashed_token(token)

    self.update_attributes!(hashed_authentication_token: hashed_token)
    return token
  end
end


