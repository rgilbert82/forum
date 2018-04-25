class ChangeTopicPostIdToForumId < ActiveRecord::Migration[5.0]
  def change
    rename_column :topics, :post_id, :forum_id
  end
end
