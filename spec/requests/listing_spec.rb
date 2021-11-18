require 'rails_helper'

RSpec.describe "Listings", type: :request do
  before(:all) do
    ## COPIED FROM seeds.rb ##
    # users
    u1 = User.create!(
      first_name: "Vishnu",
      last_name: "Nair",
      uni: "vn1234",
      email: "vn@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123"
    )
    u2 = User.create!(
      first_name: "Ivy",
      last_name: "Cao",
      uni: "ic1234",
      email: "ic@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123"
    )
    u3 = User.create!(
      first_name: "Aditya",
      last_name: "Satnalika",
      uni: "as1234",
      email: "as@columbia.edu",
      school: "SEAS",
      password: "password123",
      password_confirmation: "password123"
    )
    u4 = User.create!(
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
      image_url: "https://images-na.ssl-images-amazon.com/images/I/61xbfNmcFwL.jpg" # TODO: S3 later.
    )
    b2 = Book.create!(
      title: "Plato Symposium (Hackett Classics)",
      authors: "Plato; Alexander Nehamas; Paul Woodruff",
      edition: "1989 Edition",
      publisher: "Hackett Publishing Co",
      isbn: "9780872200760",
      image_url: "https://images-na.ssl-images-amazon.com/images/I/41vx+Jrc8GL.jpg" # TODO: S3 later.
    )
    b3 = Book.create!(
      title: "The Aeneid of Virgil (Bantam Classics)",
      authors: "Virgil; Allen Mandelbaum",
      edition: "Revised ed.",
      publisher: "Bantam Classics",
      isbn: "9780553210415",
      image_url: "https://images-na.ssl-images-amazon.com/images/I/71Rd1htsJvL.jpg" # TODO: S3 later.
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
      book_id: b1.id,
      price: 5.00,
      condition: "Like new",
      description: "Copy of the Iliad. Looks like it was never used (which may or may not have been the case)...",
      seller_id: u1.id
    )
    l2 = Listing.create!(
      book_id: b1.id,
      price: 4.50,
      condition: "Used, slightly worn",
      description: "Another copy of the Iliad. This actually looks like it was used.",
      seller_id: u2.id
    )
    l3 = Listing.create!(
      book_id: b2.id,
      price: 5.15,
      condition: "Used",
      description: "Plato's Symposium. Used.",
      seller_id: u3.id
    )
  end

  describe "GET /listing/1" do
    it "renders listing template for an existing listing" do
      get '/listing/1'
      expect(response).to render_template('show')
      expect(assigns(:listing).condition).to eq("Like new")
    end
  end

  describe "GET /listing/0" do
    it "redirect home for a non-existing listing" do
      get '/listing/0'
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Sorry, we couldn't find a listing with that ID.")
    end
  end

  describe "GET /listing/dekoewd" do
    it "redirect home if non-numeric id given" do
      get '/listing/dekoewd'
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Sorry, we couldn't find a listing with that ID.")
    end
  end

  describe "GET /listing/" do
    it "redirect home if no id given" do
      get '/listing/'
      expect(response).to redirect_to('/')
    end
  end

  # describe "Delete listing while not signed in" do
  #   it "redirects to the sign in page" do
  #     get '/listing/1/delete'
  #     expect(response).to redirect_to('/signin')
  #   end
  # end

  # describe "Delete listing while signed in" do
  #   before :each do
  #     # TODO: FIGURE THIS OUT
  #     params = {}
  #     params[:user] = {}
  #     params[:user_id] = 1
  #     params[:id] = 1
  #     params[:user][:email] = User.find_by_id(1).email
  #     params[:user][:password] = User.find_by_id(1).password
  #     post '/signin', params: params
  #   end

  #   it "redirects to /search if the listing doesn't exist" do
  #     delete '/listing/50/delete'
  #     expect(response).to redirect_to('/search')
  #   end

  #   it "redirects to /search if the listing isn't created by the user trying to delete it" do
  #     delete '/listing/2/delete'
  #     expect(response).to redirect_to('/search')
  #   end

  #   it "renders delete upon GET request" do
  #     get '/listing/1/delete'
  #     expect(response).to render_template('delete')
  #   end

  #   it "deletes listing" do
  #     delete '/listing/1/delete'
  #     expect(flash[:notice]).to eq("Listing deleted!")
  #     expect(response).to redirect_to('/search')
  #   end
  # end

  # describe "Edit listing while not signed in" do
  #   it "redirects to the sign in page" do
  #     get '/listing/1/edit'
  #     expect(response).to redirect_to('/signin')
  #   end
  # end

  # describe "Edit listing while signed in" do
  #   before :each do
  #     # TODO: FIGURE THIS OUT
  #     params = {}
  #     params[:user] = {}
  #     params[:user_id] = 1
  #     params[:id] = 1
  #     params[:user][:email] = User.find_by_id(1).email
  #     params[:user][:password] = User.find_by_id(1).password
  #     post '/signin', params: params
  #   end

  #   it "redirects to /search if the listing doesn't exist" do
  #     post '/listing/50/edit'
  #     expect(flash[:notice]).to eq("Sorry, we couldn't find a listing with that ID.")
  #     expect(response).to redirect_to('/search')
  #   end

  #   it "redirects to /search if the listing isn't created by the user trying to edit it" do
  #     post '/listing/2/edit'
  #     expect(flash[:notice]).to eq("Forbidden: Only the seller of a listing can edit that listing.")
  #     expect(response).to redirect_to('/search')
  #   end

  #   it "renders edit upon GET request" do
  #     get '/listing/1/edit'
  #     expect(response).to render_template('edit')
  #   end

  #   it "edits listing" do
  #     # TODO: Finish this
  #     post '/listing/1/edit'
  #     expect(flash[:notice]).to eq("Listing updated!")
  #     expect(response).to redirect_to('/search')
  #   end
  # end

  # describe "Create new listing while not signed in" do
  #   it "redirects to the sign in page" do
  #     get '/listing/new'
  #     expect(response).to redirect_to('/signin')
  #   end
  # end

  
end
