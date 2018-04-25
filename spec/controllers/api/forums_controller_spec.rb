require 'spec_helper'

describe Api::ForumsController do
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
    let(:alice) { Fabricate(:admin) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }

    it "sets @forum" do
      get :show, id: synth.id
      expect(assigns(:forum)).to eq(synth)
    end

    it "has a status of 200" do
      get :show, id: synth.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: synth.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:admin) }
    let(:bob) { Fabricate(:user) }

    it "creates the forum if the user is admin" do
      post :create, format: :json, data: {token: alice.token, attributes: { name: "Modular" }}
      expect(Forum.count).to eq(1)
    end

    it "does not create the forum if the user is not admin" do
      post :create, format: :json, data: {token: bob.token, attributes: { name: "Modular" }}
      expect(Forum.count).to eq(0)
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:admin) }
    let(:bob) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }

    it "updates the forum for admin user" do
      post :update, id: synth.id, format: :json, data: {token: alice.token, attributes: { name: "New Name" }}
      expect(synth.reload.name).to eq("New Name")
    end

    it "does not update the forum for non admin user" do
      post :update, id: synth.id, format: :json, data: {token: bob.token, attributes: { name: "New Name" }}
      expect(synth.reload.name).not_to eq("New Name")
    end

    it "does not update the forum for non authenticated user" do
      post :update, id: synth.id, format: :json, data: {attributes: { name: "New Name" }}
      expect(synth.reload.name).not_to eq("New Name")
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:admin) }
    let(:bob) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }

    it "deletes the forum for admin user" do
      delete :destroy, id: synth.id, format: :json, data: {token: alice.token, id: synth.id}
      expect(Forum.all).not_to include(synth)
    end

    it "does not delete the forum for non admin user" do
      delete :destroy, id: synth.id, format: :json, data: {token: bob.token, id: synth.id}
      expect(Forum.all).to include(synth)
    end

    it "does not delete the user for unauthenticated user" do
      delete :destroy, id: synth.id, format: :json, data: {id: synth.id}
      expect(Forum.all).to include(synth)
    end
  end
end
