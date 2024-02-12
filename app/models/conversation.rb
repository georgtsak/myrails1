class Conversation < ApplicationRecord
    has_many :users, class_name: 'User'
    has_many :messages
    has_many :conversationmessages
    has_many :conversationusers
end