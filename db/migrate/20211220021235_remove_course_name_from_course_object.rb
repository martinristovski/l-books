class RemoveCourseNameFromCourseObject < ActiveRecord::Migration[6.1]
  def change
    remove_column :courses, :name
  end
end
