class BookCourseAssociation < ApplicationRecord
  belongs_to :book
  belongs_to :course
end
