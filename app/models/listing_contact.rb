class ListingContact < ApplicationRecord
  belongs_to :listing
  belongs_to :initiator, class_name: "User", foreign_key: "initiator_id"
end
