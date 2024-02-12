class CreateUsersFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :users_friends do |t|
      t.references :initiator, null: false, foreign_key: true
      t.references :recepient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
