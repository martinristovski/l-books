class AddTransactionInfoFieldsToListing < ActiveRecord::Migration[6.1]
  def change
    add_column :listings, :bought_at_price, :decimal, :precision => 8, :scale => 2
    add_column :listings, :buyer_id, :integer, index: true, null: true
    add_foreign_key :listings, :users, column: :buyer_id
  end
end
