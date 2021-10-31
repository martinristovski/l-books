class CreateListingImages < ActiveRecord::Migration[6.1]
  def change
    create_table :listing_images do |t|
      t.string :image_url
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
