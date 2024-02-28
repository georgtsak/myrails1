class Conversation < ApplicationRecord
    has_many :conversation_messages, dependent: :destroy
    has_many :conversation_users, dependent: :destroy
    has_many :users, through: :conversation_users
    has_many :messages, through: :conversation_messages

    scope :direct, -> { where(direct: true) }
    after_create_commit {broadcast_append_to "conversations"}

    def user_exists?(user)
        users.map(&:id).include? user.id
    end
end