class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table :listings do |t|
      t.references :book, null: false, foreign_key: { to_table: :books }
      t.float :price, null: false
      t.string :condition
      t.text :description
      t.references :seller, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
