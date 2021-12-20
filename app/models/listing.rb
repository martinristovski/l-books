class Listing < ApplicationRecord
  @@MAX_IMAGES = 5

  belongs_to :book, optional: true
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
  belongs_to :buyer, class_name: "User", foreign_key: "buyer_id", optional: true
  belongs_to :primary_course, class_name: "Course", foreign_key: "course_id", optional: true

  enum status: {
    :draft => 0,
    :published => 10,
    :sold => 20
  }

  # expose scopes for listings
  scope :active, -> { where(status: :published) }
  scope :closed, -> { where(status: :sold) }

  # has_many :listing_bookmarks

  # a listing can have many images; if the listing is destroyed, destroy the listing images as well
  # note that this also means that the images will be automatically deleted from S3
  has_many :listing_images, dependent: :destroy

  # a listing could have a transaction rating
  has_one :transaction_rating, class_name: "UserReputationRating", foreign_key: "listing_id"
end
