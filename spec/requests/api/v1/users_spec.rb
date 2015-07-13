require 'rails_helper'

describe "Users" do
  let(:json) { JSON.parse(response.body) }
  let(:params) { nil }
  let(:headers) { nil }

  describe "#show" do
    let(:user) { FactoryGirl.create(:user) }
    let(:token) { user.generate_authentication_token }

    before do
      get "/api/v1/users/#{user.id}", params, headers
    end

    context "with an erroneous auth token" do
      it "responds with unauthorized" do
        expect(response).to have_http_status :unauthorized
      end
    end

    context "with the correct auth token" do

      context "and a valid email" do
        let(:params) { { email: user.email } }
        let(:headers) { { 'Authorization' => token } }
        it 'returns the user' do
          expect(response).to have_http_status :success
          expect(json).to eq("user" => {"id"=>1, "email"=>"my_email@example.com", "avatar"=>"http://some_domain.com", "username"=>"MyName"})
        end
      end

      context "and a valid username" do
        let(:params) { { username: user.username } }
        let(:headers) { { 'Authorization' => token } }
        it 'returns the user' do
          expect(response).to have_http_status :success
          expect(json).to eq("user" => {"id"=>1, "email"=>"my_email@example.com", "avatar"=>"http://some_domain.com", "username"=>"MyName"})
        end
      end
    end
  end

  describe "#create" do
    let(:params) {{
        user: { email: "my_email@example.com",
                username: "dougs",
                password: "great_password",
                password_confirmation: "great_password",
                avatar: "http://some_domain.com"
              }
        }}

    before do
      post "/api/v1/users", params, headers
    end

    it "creates a user" do
      expect(json["user"]).to eql({
        "id" => json["user"]["id"],
        "username" => "dougs",
        "email"=>"my_email@example.com",
        "avatar"=>"http://some_domain.com"
      })
    end
  end
end
