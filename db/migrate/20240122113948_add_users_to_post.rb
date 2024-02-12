class AddUsersToPost < ActiveRecord::Migration[7.1]
  remove_foreign_key :posts, column: :creator_id
  add_foreign_key :posts, :users, column: "creator_id"
end
