class AddDirectToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :direct, :boolean
  end
end
