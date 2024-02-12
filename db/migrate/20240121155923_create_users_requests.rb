class CreateUsersRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :users_requests do |t|
      t.references :initiator, null: false, foreign_key: true
      t.references :recepient, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
