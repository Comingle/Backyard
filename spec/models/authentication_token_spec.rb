require 'rails_helper'

describe AuthenticationToken do
  let(:auth_token) { SecureRandom.base64(24) }
  let(:hashed_auth_token) { Digest::MD5.base64digest(auth_token) }
  subject(:token) { AuthenticationToken.new(hashed_auth_token) }

  describe "#matches?" do
    it "is true when passed in the original token before it was hashed" do
      expect(subject.matches?(auth_token)).to be true
    end
  end

  describe "#to_s" do
    it "translate the hashed authenticationtoken to string" do
      expect(subject.to_s).to eql(hashed_auth_token)
    end
  end
end
