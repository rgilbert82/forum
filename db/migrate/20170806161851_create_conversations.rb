class CreateConversations < ActiveRecord::Migration[5.0]
  def change
    create_table :conversations do |t|
      t.string :title
      t.integer :sender_id
      t.integer :recipient_id
      t.boolean :sender_trash
      t.boolean :recipient_trash
      t.timestamps
    end
  end
end
