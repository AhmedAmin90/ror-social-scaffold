class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friends
  has_many :inverted_friends, class_name: 'Friend', foreign_key: 'friend_id'

  # For confirmed friends:
  has_many :confirmed_friends, -> { where status: true }, class_name: 'Friend'
  has_many :confirm_friends, through: :confirmed_friends

  # Users who needs to confirm friendship
  has_many :pending_friendships, -> { where status: nil }, class_name: 'Friend', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  def pending_list
    pending_list = []
    friends.map do |friend|
      pending_list << friend if friend.status.nil?
    end
    pending_list
  end

  def friends_list
    @friends_list = []
    friends.each do |f|
      @friends_list << f.friend if f.status == true
    end
    @friends_list
  end
end
