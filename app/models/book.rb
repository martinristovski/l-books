class Book < ApplicationRecord
  has_many :listings
  has_many :book_course_associations

  def get_published_listings
    Listing.where(status: "published", book_id: id)
  end

  def get_sold_listings
    Listing.where(status: "sold", book_id: id)
  end
end
