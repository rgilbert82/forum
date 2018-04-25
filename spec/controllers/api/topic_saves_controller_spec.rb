require 'spec_helper'

describe Api::TopicSavesController do
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
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: alice.id, forum_id: synth.id) }
    let(:save1) { Fabricate(:topic_save, user_id: alice.id, topic_id: moog.id) }

    it "sets @topic_save" do
      get :show, id: save1.id
      expect(assigns(:topic_save)).to eq(save1)
    end

    it "has a status of 200" do
      get :show, id: save1.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: save1.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: alice.id, forum_id: synth.id) }

    it "creates the save if the user is valid" do
      post :create, format: :json, data: { token: alice.token, relationships: { topic: { data: { id: moog.id } }, user: { data: { id: alice.id } } }}
      expect(TopicSave.count).to eq(1)
    end

    it "does not create the save if the user is not authenticated" do
      post :create, format: :json, data: {  relationships: { topic: { data: { id: moog.id } }, user: { data: { id: alice.id } } }}
      expect(TopicSave.count).to eq(0)
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: bob.id, forum_id: synth.id) }
    let(:save1) { Fabricate(:topic_save, user_id: alice.id, topic_id: moog.id) }

    it "deletes the save for valid user" do
      delete :destroy, id: save1.id, format: :json, data: {token: alice.token, id: save1.id}
      expect(TopicSave.all).not_to include(save1)
    end

    it "does not delete the save for non valid user" do
      delete :destroy, id: save1.id, format: :json, data: {token: bob.token, id: save1.id}
      expect(TopicSave.all).to include(save1)
    end

    it "does not delete the save for unauthenticated user" do
      delete :destroy, id: save1.id, format: :json, data: {id: save1.id}
      expect(TopicSave.all).to include(save1)
    end
  end
end
