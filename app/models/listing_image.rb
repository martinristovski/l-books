class ListingImage < ApplicationRecord
  belongs_to :listing

  before_destroy :delete_image_from_s3
  def delete_image_from_s3
    S3FileHelper.delete_file(image_id)
  end

  def self.generate_unique_name
    name = SecureRandom.uuid
    while ListingImage.where(image_id: name).count > 0
      name = SecureRandom.uuid
    end
    name
  end
end
