class DropPostReplies < ActiveRecord::Migration[5.0]
  def change
    drop_table :post_replies
  end
end
