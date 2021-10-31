class CreateUserReputationRatings < ActiveRecord::Migration[6.1]
  def change
    create_table :user_reputation_ratings do |t|
      t.references :target_user, null: false, foreign_key: { to_table: :users }
      t.references :rater_user, null: false, foreign_key: { to_table: :users }
      t.references :listing, null: false, foreign_key: { to_table: :listings }
      t.integer :score

      t.timestamps
    end
  end
end
