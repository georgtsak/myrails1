class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :messages, through: ConversationMessage
  has_many :conversations, through: ConversationUser
  has_many :contacts
  has_many :friends, through: :contacts	
end
