require 'spec_helper'

describe Topic do
  it { should belong_to(:user) }
  it { should belong_to(:forum) }

  it { should have_many(:posts).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:topic_saves).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
end
