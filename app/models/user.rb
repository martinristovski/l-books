class User < ApplicationRecord
  #adds virtual attributes for auth
  has_secure_password

  # validate that the email is in the correct format
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, format: { with: /\A(.+)@columbia\.edu\z/i , message: "Please use your Columbia email address."}

  has_many :seller_listings, class_name: "Listing", foreign_key: "seller_id"
  has_many :ratings_as_seller, class_name: "UserReputationRating", foreign_key: "target_user_id"
  has_many :saved_listings, class_name: "ListingBookmark", foreign_key: "user_id"
  has_many :purchased_listings, class_name: "Listing", foreign_key: "buyer_id"
  
  def get_num_ratings
    ratings_as_seller.count
  end
  
  def get_avg_rating
    if ratings_as_seller.count.zero?
      return 0.0
    end
    
    sum = 0
    ratings_as_seller.each do |r|
      sum += r.score
    end

    sum / ratings_as_seller.count.to_f
  end
end
