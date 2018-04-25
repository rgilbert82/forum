require 'spec_helper'

describe Conversation do
  it { should have_many(:messages).dependent(:destroy) }
  it { should belong_to(:sender) }
  it { should belong_to(:recipient) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:sender_id) }
  it { should validate_presence_of(:recipient_id) }
end
