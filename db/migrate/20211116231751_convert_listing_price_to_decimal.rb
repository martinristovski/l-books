class ConvertListingPriceToDecimal < ActiveRecord::Migration[6.1]
  def change
    change_column :listings, :price, :decimal, :precision => 8, :scale => 2
  end
end
