  require 'spec_helper'

describe Api::UsersController do
  describe "GET index" do
    it "has a status of 200" do
      get :index, format: :json
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :index, format: :json
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "GET show" do
    let(:alice) { Fabricate(:user) }

    it "sets @user" do
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it "has a status of 200" do
      get :show, id: alice.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: alice.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    it "creates the user" do
      post :create, format: :json, data: {attributes: { username: "Alice", password: 'password' }}
      expect(User.last.username).to eq("Alice")
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:admin) }

    it "updates the user for valid user" do
      post :update, id: alice.id, format: :json, data: {token: alice.token, attributes: { username: "Jane", password: 'password' }}
      expect(alice.reload.username).to eq("Jane")
    end

    it "updates the user for admin user" do
      post :update, id: alice.id, format: :json, data: {token: bob.token, attributes: { username: "Jane", password: 'password' }}
      expect(alice.reload.username).to eq("Jane")
    end

    it "does not update the user for invalid user" do
      post :update, id: bob.id, format: :json, data: {token: alice.token, attributes: { username: "Jane", password: 'password' }}
      expect(bob.reload.username).not_to eq("Jane")
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:admin) }

    it "deletes the user for valid user" do
      delete :destroy, id: alice.id, format: :json, data: {token: alice.token, id: alice.id}
      expect(User.all).not_to include(alice)
    end

    it "deletes the user for admin user" do
      delete :destroy, id: alice.id, format: :json, data: {token: bob.token, id: alice.id}
      expect(User.all).not_to include(alice)
    end

    it "does not delete the user for invalid user" do
      delete :destroy, id: bob.id, format: :json, data: {token: alice.token, id: bob.id}
      expect(User.all).to include(bob)
    end
  end
end
