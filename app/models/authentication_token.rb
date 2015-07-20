class AuthenticationToken

  attr_reader :hashed_authentication_token

  def self.to_hashed_token(token)
    new.to_hashed_token(token)
  end

  def initialize(tokenized_object = nil)
    @tokenized_object = tokenized_object
    if tokenized_object
      @hashed_authentication_token = tokenized_object.hashed_authentication_token
    end
  end

  def to_s
    @hashed_authentication_token
  end

  def matches_and_valid? token
    matches = to_hashed_token(token) == @hashed_authentication_token
    matches && @tokenized_object.token_valid?
  end

  def to_hashed_token(token)
    Digest::MD5.base64digest(token)
  end
end
