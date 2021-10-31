class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :code
      t.string :name, null: false

      t.timestamps
    end
  end
end
