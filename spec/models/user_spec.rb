require 'rails_helper'

describe User do
  subject(:user) { FactoryGirl.create(:user) }

  describe "#authentication_token" do
    let(:token) { subject.authentication_token }
    it "returns an instance of AuthenticationToken" do
      expect(token).to be_a AuthenticationToken
    end

    it "has a hashed authentication token" do
      expect(token.hashed_authentication_token).to eq(subject.hashed_authentication_token)
    end
  end

  describe "#generate_authentication_token" do
    it "returns an auth token" do
      expect(subject.generate_authentication_token).to be_a String
    end

    it "updates the user's hashed authorization token" do
      token = subject.generate_authentication_token
      expect(AuthenticationToken.to_hashed_token(token)).to eql(user.hashed_authentication_token)
    end
  end

  describe "#token_valid?" do
    before do
      user.generate_authentication_token
    end
    context "when the auth token is not expired" do
      it "returns false" do
        expect(subject.token_valid?).to eql true
      end
    end

    context "when the auth token is expired" do
      before do
        user.update_attributes(token_expires_at: 1.second.ago)
      end
      it "returns false" do
        expect(subject.token_valid?).to eql false
      end
    end
  end
end
