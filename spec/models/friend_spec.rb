require 'rails_helper'

RSpec.describe Friend, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:friend) }
  it 'Need Users before creation' do
    expect(Friend.new).to_not be_valid
  end
end
