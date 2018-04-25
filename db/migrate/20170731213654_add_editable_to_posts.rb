class AddEditableToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :editable, :boolean, default: true
  end
end
