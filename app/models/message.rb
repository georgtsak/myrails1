class Message < ApplicationRecord
  has_one :users
  has_one :conversations
end