class User < ActiveRecord::Base

  TOKEN_DURATION = 6.months
  has_many :toys
  has_many :sketches, through: :toys
  has_many :nunchucks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  attr_accessor :login

  def token_valid?
    Time.current < token_expires_at
  end

  def authentication_token
    AuthenticationToken.new(self)
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

    self.update_attributes(hashed_authentication_token: hashed_token, token_expires_at: Time.current + TOKEN_DURATION)
    return token
  end
end


