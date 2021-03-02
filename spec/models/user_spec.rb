require 'rails_helper'
RSpec.describe User, type: :model do
  subject(:user) { User.new(name: 'ahmed', email: 'ahmed@mail.com', password: 123_456) }
  it 'is valid with  attributes' do
    expect(user).to be_valid
  end
  it 'is not valid without a name' do
    user.name = nil
    expect(user).to_not be_valid
  end
  it 'is not valid without a email' do
    user.email = nil
    expect(user).to_not be_valid
  end
  it 'is not valid without a password' do
    user.password = nil
    expect(user).to_not be_valid
  end
end
