class UsersRequest < ApplicationRecord
  belongs_to :initiator
  belongs_to :recepient
end
