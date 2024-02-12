class Contact < ApplicationRecord
  belongs_to :initiator, class_name: "UserFriend", foreign_key: "initiator_id"
  belongs_to :recepient, class_name: "User", foreign_key: "recepient_id"

  def self.add_friend(initiator_id, recepient_id)
    #elegxos ean einai hdh filos
    unless UsersFriend.exists?(initiator_id: initiator_id, recepient_id: recepient_id) || UsersFriend.exists?(initiator_id: recepient_id, recepient_id: initiator_id)
      #alliws tha ginei kanonika h prosthiki epafhs
      UsersFriend.create(initiator_id: initiator_id, recepient_id: recepient_id)
    end
  end
end

