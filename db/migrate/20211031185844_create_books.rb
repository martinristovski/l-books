class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :authors
      t.string :edition
      t.string :publisher
      t.string :isbn
      t.string :photo_url

      t.timestamps
    end
  end
end
