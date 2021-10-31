class CreateListingBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :listing_bookmarks do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
