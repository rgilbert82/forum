require 'spec_helper'

describe User do
  it { should have_many(:forums).dependent(:destroy) }
  it { should have_many(:topics).dependent(:destroy) }
  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:topic_saves).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:sent_conversations).dependent(:destroy) }
  it { should have_many(:received_conversations).dependent(:destroy) }
  it { should have_many(:messages).dependent(:destroy) }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:username) }

  describe "uniqueness of username" do
    it "should not create a user with the same username as another user" do
      bob = User.create(username: 'bob', password: 'password')
      steve = User.create(username: 'bob', password: 'password')
      expect(steve).not_to be_valid
    end
  end

  describe "presence of necessary fields" do
    it "should not create a user with no username" do
      bob = User.create(username: '', password: 'password')
      expect(bob).not_to be_valid
    end

    it "should not create a user with no password" do
      bob = User.create(username: 'bob', password: '')
      expect(bob).not_to be_valid
    end
  end

  describe "#generate_token!" do
    it "generates a token when a user is created" do
      user = Fabricate(:user)
      expect(user.token).to be_present
    end
  end
end
