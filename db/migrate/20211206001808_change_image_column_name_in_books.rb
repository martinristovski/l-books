class ChangeImageColumnNameInBooks < ActiveRecord::Migration[6.1]
  def change
    rename_column :books, :image_url, :image_id
  end
end
