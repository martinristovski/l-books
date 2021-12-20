require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    # from seed file
    u1 = User.create!(
      id: 1,
      first_name: "Vishnu",
      last_name: "Nair",
      uni: "vn1234",
      email: "vn@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123",
      ratings_as_seller: []
    )
    u2 = User.create!(
      id: 2,
      first_name: "Ivy",
      last_name: "Cao",
      uni: "ic1234",
      email: "ic@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123",
      ratings_as_seller: []
    )
    b1 = Book.create!(
      title: "The Iliad of Homer",
      authors: "Richmond Lattimore; Homer",
      edition: nil,
      publisher: "University of Chicago Press",
      isbn: "9780226470498",
    )
    c1 = Course.create!(
      code: "HUMA1001"
    )
    bca1 = BookCourseAssociation.create!(
      book_id: b1.id,
      course_id: c1.id
    )
    l1 = Listing.create!(
      id: 1,
      book_id: b1.id,
      price: 5.00,
      condition: "Like new",
      description: "Copy of the Iliad. Looks like it was never used (which may or may not have been the case)...",
      seller_id: u2.id
    )
    l2 = Listing.create!(
      id: 2,
      book_id: b1.id,
      price: 4.50,
      condition: "Used, slightly worn",
      description: "Another copy of the Iliad. This actually looks like it was used.",
      seller_id: u2.id
    )
    r1 = UserReputationRating.create!(
      id: 1,
      target_user_id: 2,
      rater_user_id: 1,
      listing_id: 1,
      score: 3
    )
    r2 = UserReputationRating.create!(
      id: 2,
      target_user_id: 2,
      rater_user_id: 1,
      listing_id: 2,
      score: 4
    )
  end

  describe "Get count of ratings" do
    it "returns the number of received ratings" do
      u1 = User.find_by_id(1)
      output = u1.get_num_ratings
      expect(output).to eq(0)
    end
  end

  describe "Get average user rating (no ratings)" do
    it "shows the average to be 0" do
      u1 = User.find_by_id(1)
      output = u1.get_avg_rating
      expect(output).to eq(0.0)
    end
  end

  describe "Get average user rating (with ratings)" do
    it "shows the average" do
      u2 = User.find_by_id(2)
      output = u2.get_avg_rating
      expect(output).to eq(3.5)
    end
  end

end
