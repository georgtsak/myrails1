class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :messages
  has_many :conversations
  has_many :conversationuser, class_name: 'ConversationUser'
  has_many :contacts
  has_many :friends, through: :contacts	
end
