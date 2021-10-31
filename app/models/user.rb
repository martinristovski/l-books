class User < ApplicationRecord
  # validate that the email is in the correct format
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :seller_listings, class_name: "Listing", foreign_key: "seller_id"
  has_many :listing_bookmarks
  has_many :user_reputation_ratings
end
