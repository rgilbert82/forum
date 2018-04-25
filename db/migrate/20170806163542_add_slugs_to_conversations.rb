class AddSlugsToConversations < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :slug, :string
  end
end
