class AddCourseUsedToListing < ActiveRecord::Migration[6.1]
  def change
    add_column :listings, :course_id, :integer, index: true, null: true
    add_foreign_key :listings, :courses, column: :course_id
  end
end
