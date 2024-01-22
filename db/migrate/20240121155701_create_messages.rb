class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :creator, null: false, foreign_key: true
      t.references :recepient, null: false, foreign_key: true
      t.string :value
      t.datetime :createdon

      t.timestamps
    end
  end
end
