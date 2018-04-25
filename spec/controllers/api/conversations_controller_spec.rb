require 'spec_helper'

describe Api::ConversationsController do
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
    let(:bob) { Fabricate(:user) }
    let(:conversation1) { Fabricate(:conversation, sender_id: alice.id, recipient_id: bob.id) }

    it "sets @conversation" do
      get :show, id: conversation1.id
      expect(assigns(:conversation)).to eq(conversation1)
    end

    it "has a status of 200" do
      get :show, id: conversation1.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: conversation1.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }

    it "creates the conversation if the user is valid" do
      post :create, format: :json, data: { token: alice.token, attributes: { title: "Hello" }, relationships: { sender: { data: { id: alice.id } }, recipient: { data: { id: bob.id } } }}
      expect(Conversation.count).to eq(1)
    end

    it "does not create the conversation if the user is not authenticated" do
      post :create, format: :json, data: { attributes: { title: "Hello" }, relationships: { sender: { data: { id: alice.id } }, recipient: { data: { id: bob.id } } }}
      expect(Conversation.count).to eq(0)
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:carl) { Fabricate(:user) }
    let(:conversation1) { Fabricate(:conversation, sender_id: alice.id, recipient_id: bob.id) }

    it "updates the conversation for valid user" do
      post :update, id: conversation1.id, format: :json, data: { token: alice.token, attributes: { "sender-trash": true }}
      expect(conversation1.reload.sender_trash).to eq(true)
    end

    it "does not update the conversation for non valid user" do
      post :update, id: conversation1.id, format: :json, data: { token: carl.token, attributes: { "sender-trash": true }}
      expect(conversation1.reload.sender_trash).to eq(false)
    end

    it "does not update the conversation for non authenticated user" do
      post :update, id: conversation1.id, format: :json, data: { attributes: { "sender-trash": true }}
      expect(conversation1.reload.sender_trash).to eq(false)
    end
  end
end
