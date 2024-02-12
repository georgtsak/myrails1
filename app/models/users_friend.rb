class UsersFriend < ApplicationRecord
  belongs_to :initiator, class_name: "User"
  belongs_to :recipient, class_name: "User"
end
