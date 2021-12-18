class ChangeBuyerIdFieldTypeInListing < ActiveRecord::Migration[6.1]
  def change
    change_column :listings, :buyer_id, :bigint
  end
end
