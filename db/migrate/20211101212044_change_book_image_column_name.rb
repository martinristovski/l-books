class ChangeBookImageColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :books, :photo_url, :image_url
  end
end
