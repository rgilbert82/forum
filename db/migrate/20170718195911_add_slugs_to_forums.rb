class AddSlugsToForums < ActiveRecord::Migration[5.0]
  def change
    add_column :forums, :slug, :string
  end
end
