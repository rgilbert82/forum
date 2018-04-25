require 'spec_helper'

describe Api::TopicsController do
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
    let(:moog) { Fabricate(:topic, user_id: alice.id, forum_id: synth.id) }

    it "sets @topic" do
      get :show, id: moog.id
      expect(assigns(:topic)).to eq(moog)
    end

    it "has a status of 200" do
      get :show, id: moog.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: moog.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }

    it "creates the topic if the user is valid" do
      post :create, format: :json, data: { token: alice.token, attributes: { title: "Voyager", body: "blah blah blah" }, relationships: { forum: { data: { id: synth.id } } }}
      expect(Topic.count).to eq(1)
    end

    it "does not create the topic if the user is not valid" do
      post :create, format: :json, data: { attributes: { title: "Voyager", body: "blah blah blah" }, relationships: { forum: { data: { id: synth.id } } }}
      expect(Topic.count).to eq(0)
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:admin) }
    let(:bob) { Fabricate(:user) }
    let(:carl) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: bob.id, forum_id: synth.id) }

    it "updates the topic for admin user" do
      post :update, id: moog.id, format: :json, data: { token: alice.token, attributes: { title: "New Title", body: "blah blah blah" }, relationships: { forum: { data: { id: synth.id } } }}
      expect(moog.reload.title).to eq("New Title")
    end

    it "updates the topic for valid user" do
      post :update, id: moog.id, format: :json, data: { token: bob.token, attributes: { title: "New Title", body: "blah blah blah" }, relationships: { forum: { data: { id: synth.id } } }}
      expect(moog.reload.title).to eq("New Title")
    end

    it "does not update the topic for non valid user" do
      post :update, id: moog.id, format: :json, data: { token: carl.token, attributes: { title: "New Title", body: "blah blah blah" }, relationships: { forum: { data: { id: synth.id } } }}
      expect(moog.reload.title).not_to eq("New Title")
    end

    it "does not update the topic for non authenticated user" do
      post :update, id: moog.id, format: :json, data: { attributes: { title: "New Title", body: "blah blah blah" }, relationships: { forum: { data: { id: synth.id } } }}
      expect(moog.reload.title).not_to eq("New Title")
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:admin) }
    let(:bob) { Fabricate(:user) }
    let(:carl) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: bob.id, forum_id: synth.id) }

    it "deletes the topic for admin user" do
      delete :destroy, id: moog.id, format: :json, data: {token: alice.token, id: moog.id}
      expect(Topic.all).not_to include(moog)
    end

    it "deletes the topic for valid user" do
      delete :destroy, id: moog.id, format: :json, data: {token: bob.token, id: moog.id}
      expect(Topic.all).not_to include(moog)
    end

    it "does not delete the topic for non valid user" do
      delete :destroy, id: moog.id, format: :json, data: {token: carl.token, id: moog.id}
      expect(Topic.all).to include(moog)
    end

    it "does not delete the topic for unauthenticated user" do
      delete :destroy, id: moog.id, format: :json, data: {id: moog.id}
      expect(Topic.all).to include(moog)
    end
  end
end
