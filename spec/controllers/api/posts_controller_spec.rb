require 'spec_helper'

describe Api::PostsController do
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
    let(:post1) { Fabricate(:post, user_id: alice.id, topic_id: moog.id) }

    it "sets @post" do
      get :show, id: post1.id
      expect(assigns(:post)).to eq(post1)
    end

    it "has a status of 200" do
      get :show, id: post1.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: post1.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: alice.id, forum_id: synth.id) }

    it "creates the post if the user is valid" do
      post :create, format: :json, data: { token: alice.token, attributes: { body: "blah blah blah" }, relationships: { topic: { data: { id: moog.id } } }}
      expect(Post.count).to eq(1)
    end

    it "creates a reply for a post if the user is valid" do
      post :create, format: :json, data: { token: alice.token, attributes: { body: "blah blah blah" }, relationships: { topic: { data: { id: moog.id } } }}
      post :create, format: :json, data: { token: alice.token, attributes: { body: "hello" }, relationships: { topic: { data: { id: moog.id } }, parent: { data: { id: Post.first.id } } }}
      expect(Post.first.reload.replies.count).to eq(1)
    end

    it "does not create the post if the user is not authenticated" do
      post :create, format: :json, data: { attributes: { body: "blah blah blah" }, relationships: { topic: { data: { id: moog.id } } }}
      expect(Post.count).to eq(0)
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:admin) }
    let(:bob) { Fabricate(:user) }
    let(:carl) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: bob.id, forum_id: synth.id) }
    let(:post1) { Fabricate(:post, user_id: bob.id, topic_id: moog.id) }

    it "updates the post for admin user" do
      post :update, id: post1.id, format: :json, data: { token: alice.token, attributes: { body: "hello" }, relationships: { topic: { data: { id: moog.id } } }}
      expect(post1.reload.body).to eq("hello")
    end

    it "updates the post for valid user" do
      post :update, id: post1.id, format: :json, data: { token: bob.token, attributes: { body: "hello" }, relationships: { topic: { data: { id: moog.id } } }}
      expect(post1.reload.body).to eq("hello")
    end

    it "does not update the post for non valid user" do
      post :update, id: post1.id, format: :json, data: { token: carl.token, attributes: { body: "hello" }, relationships: { topic: { data: { id: moog.id } } }}
      expect(post1.reload.body).not_to eq("hello")
    end

    it "does not update the post for non authenticated user" do
      post :update, id: post1.id, format: :json, data: { attributes: { body: "hello" }, relationships: { topic: { data: { id: moog.id } } }}
      expect(post1.reload.body).not_to eq("hello")
    end
  end
end
