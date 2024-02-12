class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :content
      t.references :users, null: false, foreign_key: true

      t.timestamps
    end
    add_index :messages, :id, unique: true
  end
end
