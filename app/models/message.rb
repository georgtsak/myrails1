class Message < ApplicationRecord
  has_many :user
  has_many :conversation
end