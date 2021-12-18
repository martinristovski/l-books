require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
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
      code: "HUMA1001",
      name: "Masterpieces of Western Literature and Philosophy I"
    )
    c2 = Course.create!(
      code: "HUMA1002",
      name: "Masterpieces of Western Literature and Philosophy II"
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
      seller_id: u1.id
    )
    l2 = Listing.create!(
      id: 2,
      book_id: b1.id,
      price: 4.50,
      condition: "Used, slightly worn",
      description: "Another copy of the Iliad. This actually looks like it was used.",
      seller_id: u2.id
    )
    l3 = Listing.create!(
      id: 3,
      book_id: b2.id,
      price: 5.15,
      condition: "Used",
      description: "Plato's Symposium. Used.",
      seller_id: u3.id
    )
  end

  describe "Create listing bookmark without being logged in" do
    it "redirects to the sign in page" do
      get '/listing/1/bookmark'
      expect(response).to redirect_to('/signin')
    end
  end

  describe "While signed in, create/remove listing bookmark" do
    before :each do
      params = {:email => "vn@columbia.edu", :password => "password123"}
      post '/signin', params: params
      expect(session[:user_id]).to eq(1)
    end

    it "notifies you and goes back to search for invalid id" do
      get '/listing/8/bookmark'
      expect(flash[:notice]).to eq("Sorry, we couldn't find a listing with that ID.")
      expect(response).to redirect_to('/')
    end

    it "notifies you and goes back to listing for id of own listing" do
      get '/listing/1/bookmark'
      expect(flash[:notice]).to eq("Cannot bookmark your own listing.")
      expect(response).to redirect_to('/listing/1')
    end

    it "creates the bookmark" do
      get '/listing/2/bookmark'
      expect(flash[:notice]).to eq('Listing bookmarked!')
      expect(response).to redirect_to('/listing/2')
    end

    it "removes an existing bookmark" do
      get '/listing/3/bookmark'
      expect(flash[:notice]).to eq('Listing bookmarked!')
      expect(response).to redirect_to('/listing/3')

      get '/listing/3/bookmark'
      expect(flash[:notice]).to eq('Bookmark removed!')
      expect(response).to redirect_to('/listing/3')
    end
  end

end
