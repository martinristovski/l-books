class User < ApplicationRecord
  #adds virtual attributes for auth
  has_secure_password

  # validate that the email is in the correct format
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :seller_listings, class_name: "Listing", foreign_key: "seller_id"
  has_many :user_reputation_ratings
end
