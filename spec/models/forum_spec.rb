require 'spec_helper'

describe Forum do
  it { should have_many(:topics).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:name) }
end
