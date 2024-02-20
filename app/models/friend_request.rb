class FriendRequest < ApplicationRecord
  belongs_to :user

  def self.reacted?(id1, id2)
    type1 = !FriendRequest.where(user_id: id1, friend_id: id2).empty?
    type2 = !FriendRequest.where(user_id: id2, friend_id: id1).empty?
    type1 || type2
  end

  def self.confirmed_record?(id1, id2)
    type1 = !FriendRequest.where(user_id: id1, friend_id: id2, accepted: true).empty?
    type2 = !FriendRequest.where(user_id: id2, friend_id: id1, accepted: true).empty?
    type1 || type2
  end

  def self.find_request(id1, id2)
    if FriendRequest.where(user_id: id1, friend_id: id2, accepted: true).empty?
      FriendRequest.where(user_id: id2, friend_id: id1, accepted: true)[0].id
    else
      FriendRequest.where(user_id: id1, friend_id: id2, accepted: true)[0].id
    end
  end
end
