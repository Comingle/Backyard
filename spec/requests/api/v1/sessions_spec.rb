require 'rails_helper'

describe "Sessions" do
  let(:json) { JSON.parse(response.body) }
  let(:params) { nil }
  let(:headers) { nil }
  let(:password) { "great_password" }
  let(:username) { "great_name" }
  let(:email) { 'my_email@example.com' }
  let!(:user) { FactoryGirl.create(:user,
                                   username: username,
                                   email: email,
                                   password: password,
                                   password_confirmation: password)}

  describe "#create" do
    before do
      post "/api/v1/sessions", params, headers
    end

    context "with a valid password" do

      context "using an email identifier" do
        let(:params) { {session: { identifier: email, password: password }} }
        it "renders the session" do
          expect(json.keys).to include('authentication_token')
        end
      end

      context "using a username identifier" do
        let(:params) { {session: {identifier: username, password: password }} }
        it "renders the session" do
          expect(json.keys).to include('authentication_token')
        end
      end

      context "with a bad identifier" do
        let(:params) { { session: { identifier: 'not_my_email@example.com', password: password }} }
        it "responds with not found error" do
          expect(response).to have_http_status :not_found
        end
      end
    end

    context "with a bad password" do
      let(:params) { { identifier: 'my_email@example.com', password: "bad_password" } }
      it "responds with not found" do
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe "#destroy" do
    before do
      delete "/api/v1/sessions/#{user.id}", params, headers
    end

    it "it deletes the user's hashed authentication token" do
      expect(user.hashed_authentication_token).to be nil
    end
  end
end
