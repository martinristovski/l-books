class Listing < ApplicationRecord
  belongs_to :book
  belongs_to :seller, class_name: "User", foreign_key: "seller_id"
end
