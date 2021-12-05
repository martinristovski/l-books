class RemoveNullConstraintForBookFkInListing < ActiveRecord::Migration[6.1]
  def change
    change_column_null :listings, :book_id, true
  end
end
