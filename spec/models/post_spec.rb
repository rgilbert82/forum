require 'spec_helper'

describe Post do
  it { should belong_to(:user) }
  it { should belong_to(:topic) }
  it { should belong_to(:parent) }

  it { should have_many(:replies) }
end
