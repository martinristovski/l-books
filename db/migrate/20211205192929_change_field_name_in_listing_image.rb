class ChangeFieldNameInListingImage < ActiveRecord::Migration[6.1]
  def change
    rename_column :listing_images, :image_url, :image_id
  end
end
