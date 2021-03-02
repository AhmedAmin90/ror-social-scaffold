require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'assoiations present' do
    it { should belong_to(:user) }
  end
  describe 'content presence' do
    it 'if contnet present' do
      e = Comment.new
      e.content = 'pass'
      e.valid?
      expect(e.errors[:content]).not_to include("can't be blank")
    end
    it 'if content not present' do
      e = Comment.new
      e.content = ''
      e.valid?
      expect(e.errors[:content]).to include("can't be blank")
    end
  end
end
