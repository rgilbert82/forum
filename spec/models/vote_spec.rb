require 'spec_helper'

describe Vote do
  it { should belong_to(:user) }
  it { should belong_to(:topic) }

  it { should validate_uniqueness_of(:topic_id).scoped_to(:user_id) }
end
