class User < ApplicationRecord
  # validate that the email is in the correct format
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
