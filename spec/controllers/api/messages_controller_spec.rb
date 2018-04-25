require 'spec_helper'

describe Api::MessagesController do
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
    let(:message1) { Fabricate(:message, user_id: alice.id, conversation_id: conversation1.id) }

    it "sets @message" do
      get :show, id: message1.id
      expect(assigns(:message)).to eq(message1)
    end

    it "has a status of 200" do
      get :show, id: message1.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: message1.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:carl) { Fabricate(:user) }
    let(:conversation1) { Fabricate(:conversation, sender_id: alice.id, recipient_id: bob.id) }

    it "creates the message if the user is valid" do
      post :create, format: :json, data: { token: alice.token, attributes: { body: "Hello" }, relationships: { user: { data: { id: alice.id } }, conversation: { data: { id: conversation1.id } } }}
      expect(Message.count).to eq(1)
    end

    it "does not create the message if the user is not valid" do
      post :create, format: :json, data: { token: carl.token, attributes: { body: "Hello" }, relationships: { user: { data: { id: alice.id } }, conversation: { data: { id: conversation1.id } } }}
      expect(Message.count).to eq(0)
    end

    it "does not create the conversation if the user is not authenticated" do
      post :create, format: :json, data: { attributes: { body: "Hello" }, relationships: { user: { data: { id: alice.id } }, conversation: { data: { id: conversation1.id } } }}
      expect(Message.count).to eq(0)
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:carl) { Fabricate(:user) }
    let(:conversation1) { Fabricate(:conversation, sender_id: alice.id, recipient_id: bob.id) }
    let(:message1) { Fabricate(:message, user_id: alice.id, conversation_id: conversation1.id) }

    it "updates the message for valid user" do
      post :update, id: message1.id, format: :json, data: { token: alice.token, attributes: { unread: "false", body: "hello" }}
      expect(message1.reload.body).to eq("hello")
    end

    it "does not update the message for non valid user" do
      post :update, id: message1.id, format: :json, data: { token: carl.token, attributes: { unread: "false" }}
      expect(message1.reload.unread).to eq(true)
    end

    it "does not update the message for non authenticated user" do
      post :update, id: message1.id, format: :json, data: { attributes: { unread: "false" }}
      expect(message1.reload.unread).to eq(true)
    end
  end
end
