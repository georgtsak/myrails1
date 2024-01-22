class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :content
      t.datetime :createdon
      t.references :creator, null: false, foreign_key: true

      t.timestamps
    end
    add_index :posts, :id, unique: true
  end
end
