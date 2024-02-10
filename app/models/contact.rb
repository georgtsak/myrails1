class Contact < ApplicationRecord
  belongs_to :initiator, class_name: "User"
  belongs_to :recipient, class_name: "User"

  def self.add_friend(initiator_id, recipient_id)
    unless exists?(initiator_id: initiator_id, recipient_id: recipient_id) || exists?(initiator_id: recipient_id, recipient_id: initiator_id) #ean einai hdh filos
    create(initiator_id: initiator_id, recipient_id: recipient_id)
    end
  end
end
