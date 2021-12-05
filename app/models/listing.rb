class Listing < ApplicationRecord
  @@MAX_IMAGES = 5

  belongs_to :book, optional: true
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"

  enum status: {
    :draft => 0,
    :published => 10,
    :sold => 20
  }

  # has_many :listing_bookmarks

  # a listing can have many images; if the listing is destroyed, destroy the listing images as well
  # note that this also means that the images will be automatically deleted from S3
  has_many :listing_images, dependent: :destroy
end
