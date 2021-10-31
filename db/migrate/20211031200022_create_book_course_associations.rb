class CreateBookCourseAssociations < ActiveRecord::Migration[6.1]
  def change
    create_table :book_course_associations do |t|
      t.references :book, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end

    # the association itself should be unique
    add_index :book_course_associations, [:book_id, :course_id], unique: true
  end
end
