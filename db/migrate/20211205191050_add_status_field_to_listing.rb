class AddStatusFieldToListing < ActiveRecord::Migration[6.1]
  def change
    add_column :listings, :status, :integer
  end
end
