require 'rails_helper'

RSpec.describe "TransactionRatings", type: :request do
  before(:all) do
    ## COPIED FROM seeds.rb ##
    # users
    u1 = User.create!(
      id: 1,
      first_name: "Vishnu",
      last_name: "Nair",
      uni: "vn1234",
      email: "vn@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123"
    )
    u2 = User.create!(
      id: 2,
      first_name: "Ivy",
      last_name: "Cao",
      uni: "ic1234",
      email: "ic@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123"
    )
    u3 = User.create!(
      id: 3,
      first_name: "Aditya",
      last_name: "Satnalika",
      uni: "as1234",
      email: "as@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123"
    )
    u4 = User.create!(
      id: 4,
      first_name: "Martin",
      last_name: "Ristovski",
      uni: "mr1234",
      email: "mr@columbia.edu",
      school: "CC",
      password: "password123",
      password_confirmation: "password123"
    )

    # books
    b1 = Book.create!(
      title: "The Iliad of Homer",
      authors: "Richmond Lattimore; Homer",
      edition: nil,
      publisher: "University of Chicago Press",
      isbn: "9780226470498",
    )
    b2 = Book.create!(
      title: "Plato Symposium (Hackett Classics)",
      authors: "Plato; Alexander Nehamas; Paul Woodruff",
      edition: "1989 Edition",
      publisher: "Hackett Publishing Co",
      isbn: "9780872200760",
    )
    b3 = Book.create!(
      title: "The Aeneid of Virgil (Bantam Classics)",
      authors: "Virgil; Allen Mandelbaum",
      edition: "Revised ed.",
      publisher: "Bantam Classics",
      isbn: "9780553210415",
    )

    # courses
    c1 = Course.create!(
      code: "HUMA1001"
    )
    c2 = Course.create!(
      code: "HUMA1002"
    )

    # book-course associations
    bca1 = BookCourseAssociation.create!(
      book_id: b1.id,
      course_id: c1.id
    )
    bca2 = BookCourseAssociation.create!(
      book_id: b2.id,
      course_id: c1.id
    )
    bca3 = BookCourseAssociation.create!(
      book_id: b3.id,
      course_id: c1.id
    )

    # listings
    l1 = Listing.create!(
      id: 1,
      book_id: b1.id,
      price: 5.00,
      condition: "Like new",
      description: "Copy of the Iliad. Looks like it was never used (which may or may not have been the case)...",
      course_id: c1.id,
      seller_id: u1.id
    )
    l2 = Listing.create!(
      id: 2,
      book_id: b1.id,
      price: 4.50,
      condition: "Used, slightly worn",
      description: "Another copy of the Iliad. This actually looks like it was used.",
      course_id: c1.id,
      seller_id: u2.id
    )
    l3 = Listing.create!(
      id: 3,
      book_id: b2.id,
      price: 5.15,
      condition: "Used",
      description: "Plato's Symposium. Used.",
      course_id: c1.id,
      seller_id: u3.id
    )
    l4 = Listing.create!(
      id: 4,
      book_id: b1.id,
      price: 5.00,
      condition: "Like new",
      description: "Copy of the Iliad. Looks like it was never used (which may or may not have been the case)...",
      seller_id: u2.id,
      status: "sold",
      bought_at_price: 5.00,
      course_id: c1.id,
      buyer_id: u1.id
    )
  end

#   post '/listing/:id/rate', to: 'transaction_rating#submit'

  describe "When not signed in" do
    it "redirects to sign in" do
      get '/listing/1/rate'
      expect(response).to redirect_to('/signin')
    end

    it "redirects to sign in" do
      post '/listing/1/rate'
      expect(response).to redirect_to('/signin')
    end
  end

  describe "When signed in" do
    before :each do
      params = {:email => "vn@columbia.edu", :password => "password123"}
      post '/signin', params: params
      expect(session[:user_id]).to eq(1)
    end

    it "shows warning when listing not found" do
      get '/listing/8/rate'
      expect(flash[:notice]).to eq("Could not find the listing you are looking for.")
      expect(response).to redirect_to('/')
    end

    it "shows warning when user can't rate that transaction" do
      get '/listing/2/rate'
      expect(flash[:notice]).to eq("You cannot rate this transaction.")
      expect(response).to redirect_to('/')
    end

    it "shows the rating when it exists" do
      get '/listing/4/rate'
      expect(response).to render_template("transaction_rating/form", "layouts/other_pages")
    end

    it "shows warning when listing not found" do
      post '/listing/8/rate'
      expect(flash[:notice]).to eq("Could not find the listing you are looking for.")
      expect(response).to redirect_to('/')
    end

    it "shows warning for invalid rating" do
      params = {:rating => "A"}
      post '/listing/1/rate', params: params

      expect(flash[:notice]).to eq("Invalid rating.")
      expect(response).to redirect_to('/listing/1/rate')
    end

    it "creates new rating if current one doesn't exist (and allows for editing it)" do
      params = {:rating => '4'}
      post '/listing/4/rate', params: params

      expect(flash[:notice]).to eq("Rating submitted!")
      expect(response).to redirect_to('/listing/4')

      # verify that we see the correct rating on the listing's page
      get '/listing/4'
      expect(response.body).to include("The Iliad of Homer")
      expect(response.body).to include("Edit Rating (gave 4/5)")

      # edit the rating
      params = {:rating => '5'}
      post '/listing/4/rate', params: params

      # verify that we see the NEW rating on the listing's page
      get '/listing/4'
      expect(response.body).to include("The Iliad of Homer")
      expect(response.body).to include("Edit Rating (gave 5/5)")
    end

  end

end