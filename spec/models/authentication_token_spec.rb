require 'rails_helper'

describe AuthenticationToken do
  let(:tokenized_object) { FactoryGirl.create(:user) }
  let!(:auth_token) { tokenized_object.generate_authentication_token }
  let(:hashed_auth_token) { Digest::MD5.base64digest(auth_token) }
  subject(:token) { AuthenticationToken.new(tokenized_object) }

  describe "#matches_and_valid?" do
    describe "when passed in the original token before it was hashed" do
      it "returns true" do
        expect(subject.matches_and_valid?(auth_token)).to be true
      end

      describe "when the tokenized object has an expired token" do
        before do
          tokenized_object.token_expires_at = 1.second.ago
        end
        it "returns true" do
          expect(subject.matches_and_valid?(auth_token)).to be false
        end
      end
    end

    describe "when passed a random auth token" do
      it "returns false" do
        expect(subject.matches_and_valid?('random token')).to be false
      end
    end
  end

  describe "#to_s" do
    it "translate the hashed authenticationtoken to string" do
      expect(subject.to_s).to eql(hashed_auth_token)
    end
  end
end
