require 'rails_helper'

RSpec.describe ListingImage, type: :model do
  describe "Get a rdndom UUID" do
    it "returns a properly-formatted UUID" do
      generated = ListingImage.generate_unique_name
      expect(generated.length).to be(36)
      expect(generated.count('-')).to be(4)
    end
  end
end
