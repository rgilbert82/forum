require 'spec_helper'

describe Api::VotesController do
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
    let(:vote1) { Fabricate(:vote, user_id: alice.id, topic_id: moog.id) }

    it "sets @vote" do
      get :show, id: vote1.id
      expect(assigns(:vote)).to eq(vote1)
    end

    it "has a status of 200" do
      get :show, id: vote1.id
      expect(response.code).to eq("200")
    end

    it "responds with JSON content" do
      get :show, id: vote1.id
      response.header['Content-Type'].should include 'application/vnd.api+json'
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: alice.id, forum_id: synth.id) }

    it "creates the vote if the user is valid" do
      post :create, format: :json, data: { token: alice.token, attributes: { vote: true }, relationships: { topic: { data: { id: moog.id } }, user: { data: { id: alice.id } } }}
      expect(Vote.count).to eq(1)
    end

    it "does not create the vote if the user is not authenticated" do
      post :create, format: :json, data: { attributes: { vote: true }, relationships: { topic: { data: { id: moog.id } }, user: { data: { id: alice.id } } }}
      expect(Vote.count).to eq(0)
    end
  end

  describe "PATCH update" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: bob.id, forum_id: synth.id) }
    let(:vote1) { Fabricate(:vote, user_id: alice.id, topic_id: moog.id) }

    it "updates the vote for valid user" do
      post :update, id: vote1.id, format: :json, data: { token: alice.token, attributes: { vote: false }}
      expect(vote1.reload.vote).to eq(false)
    end

    it "does not update the vote for non valid user" do
      post :update, id: vote1.id, format: :json, data: { token: bob.token, attributes: { vote: false }}
      expect(vote1.reload.vote).to eq(true)
    end

    it "does not update the vote for non authenticated user" do
      post :update, id: vote1.id, format: :json, data: { attributes: { vote: false }}
      expect(vote1.reload.vote).to eq(true)
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:bob) { Fabricate(:user) }
    let(:synth) { Fabricate(:forum, user_id: alice.id) }
    let(:moog) { Fabricate(:topic, user_id: bob.id, forum_id: synth.id) }
    let(:vote1) { Fabricate(:vote, user_id: alice.id, topic_id: moog.id) }

    it "deletes the vote for valid user" do
      delete :destroy, id: vote1.id, format: :json, data: {token: alice.token, id: vote1.id}
      expect(Vote.all).not_to include(vote1)
    end

    it "does not delete the vote for non valid user" do
      delete :destroy, id: vote1.id, format: :json, data: {token: bob.token, id: vote1.id}
      expect(Vote.all).to include(vote1)
    end

    it "does not delete the vote for unauthenticated user" do
      delete :destroy, id: vote1.id, format: :json, data: {id: vote1.id}
      expect(Vote.all).to include(vote1)
    end
  end
end
