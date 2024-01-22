class Message < ApplicationRecord
  belongs_to :creator
  belongs_to :recepient
end
