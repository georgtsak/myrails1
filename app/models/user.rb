class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :posts, dependent: :destroy
  has_many :conversation_messages, dependent: :destroy
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users
  has_many :messages, through: :conversation_messages, dependent: :destroy
  has_many :notifications, as: :recipient, class_name: "Noticed::Notification"

  scope :all_except, ->(user) { where.not(id: user) }

  def self.from_google(u)
    create_with(uid: u[:uid], provider: 'google', password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      # Additional user attributes can be set here based on the auth response
    end
  end

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

  def find_direct_with(user)
    self.conversations.direct.where(:conversation_users => { user_id: [self.id, user.id] } )
  end
end
