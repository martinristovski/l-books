class RemoveNullConstraintForPriceInListing < ActiveRecord::Migration[6.1]
  def change
    change_column_null :listings, :price, true
  end
end
