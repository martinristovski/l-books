class Book < ApplicationRecord
  has_many :listings
  has_many :book_course_associations
end
