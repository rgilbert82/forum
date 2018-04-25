require 'spec_helper'

describe Api::SessionsController do
  describe "GET show" do
    let(:alice) { Fabricate(:user) }

    it "sets @user" do
      get :show, id: alice.token
      expect(assigns(:user)).to eq(alice)
    end

    it "does not set @user for unidentified tokens" do
      get :show, id: "12345"
      expect(assigns(:user)).to be_nil
    end

    it "has a status of 200" do
      get :show, id: alice.token
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: alice.token
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end
end
