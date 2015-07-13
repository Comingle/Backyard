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
    to_hashed_token(token) == @hashed_authentication_token
  end

  def to_hashed_token(token)
    Digest::MD5.base64digest(token)
  end
end
