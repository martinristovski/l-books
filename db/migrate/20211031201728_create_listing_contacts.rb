class CreateListingContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :listing_contacts do |t|
      t.references :listing, null: false, foreign_key: true
      t.datetime :contact_timestamp
      t.references :initiator, null: false, foreign_key: { to_table: :users }
      t.text :message

      t.timestamps
    end
  end
end
