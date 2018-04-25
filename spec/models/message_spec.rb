require 'spec_helper'

describe Message do
  it { should belong_to(:user) }
  it { should belong_to(:conversation) }

  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:conversation_id) }
end
