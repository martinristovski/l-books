class UserReputationRating < ApplicationRecord
  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"
  belongs_to :rater_user, class_name: "User", foreign_key: "rater_user_id"
  belongs_to :listing
end
