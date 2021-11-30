class Book < ApplicationRecord
  has_many :listings
  has_many :book_course_associations
  has_one_attached :cover_image
end
