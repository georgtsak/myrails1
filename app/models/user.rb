class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :conversation_messages, dependent: :destroy
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users
  has_many :messages, through: :conversation_messages, dependent: :destroy
  has_many :notifications, as: :recipient, class_name: "Noticed::Notification"

  scope :all_except, ->(user) { where.not(id: user) }

  def friends
    friends_sent = FriendRequest.where(user_id: id, accepted: true).pluck(:friend_id)
    friends_received = FriendRequest.where(friend_id: id, accepted: true).pluck(:user_id)
    total_friends = friends_sent + friends_received

    User.where(id: total_friends)
  end

  def pending_sent
    friends_sent = FriendRequest.where(user_id: id, accepted: false).pluck(:friend_id)
    total_friends = friends_sent
    User.where(id: total_friends)
  end

  def pending_received
    friends_received = FriendRequest.where(friend_id: id, accepted: false).pluck(:user_id)
    total_friends = friends_received
    User.where(id: total_friends)
  end

  def has_request?(user)
    FriendRequest.reacted?(id, user.id)
  end

  def friend_with?(user)
    FriendRequest.confirmed_record?(id, user.id)
  end

  def add_friend(user)
    FriendRequests.create(friend_id: user.id)
  end
end
