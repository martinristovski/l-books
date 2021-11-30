class RemoveImageUrlFromBook < ActiveRecord::Migration[6.1]
  def change
    remove_column :books, :image_url
  end
end
