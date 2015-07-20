require 'scrypt'
SCrypt::Engine.calibrate!(max_mem: 4 * 1024 * 1024)

class AuthenticationToken

  attr_reader :hashed_authentication_token

  def self.to_hashed_token(token)
    new.to_hashed_token(token)
  end

  def initialize(hashed_authentication_token = nil)
    @hashed_authentication_token = hashed_authentication_token
  end

  def to_s
    @hashed_authentication_token
  end

  def matches? token
    SCrypt::Password.new(@hashed_authentication_token) == token
  end

  def to_hashed_token(token)
    SCrypt::Password.create(token)
  end
end
