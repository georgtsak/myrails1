class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :conversation_messages, dependent: :destroy
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users
  has_many :messages, through: :conversation_messages
  has_many :contacts
  has_many :friends, through: :contacts
  has_many :notifications, as: :recipient, dependent: :destroy
end
