class AddAvatarToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :avatar, :string
  end
end
