class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :value

      t.timestamps
    end
    add_index :messages, :id, unique: true
  end
end
