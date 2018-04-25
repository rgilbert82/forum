class CreatePostReplies < ActiveRecord::Migration[5.0]
  def change
    create_table :post_replies do |t|
      t.integer :post_id
      t.integer :reply_id
      t.timestamps
    end
  end
end
