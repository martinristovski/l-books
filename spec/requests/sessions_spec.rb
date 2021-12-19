require 'rails_helper'

RSpec.describe "Sessions", type: :request do
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
    b1 = Book.create!(
      title: "The Iliad of Homer",
      authors: "Richmond Lattimore; Homer",
      edition: nil,
      publisher: "University of Chicago Press",
      isbn: "9780226470498",
      )
    l1 = Listing.create!(
      id: 1,
      book_id: b1.id,
      price: 5.00,
      condition: "Like new",
      description: "Copy of the Iliad. Looks like it was never used (which may or may not have been the case)...",
      seller_id: u1.id
    )
  end

  describe "Go to sign in page" do
    it "renders the sign in page" do
      get '/signin'

      expect(response.body).to match("Sign In")
      expect(response.body).to match("Email:")
      expect(response.body).to match("Password:")
      expect(response.body).to match("Log In")
    end
  end

  describe "Log in user" do
    it "renders new with nil user" do
      params = {}
      params[:email] = "fake@email.com"
      params[:password] = "loremipsum"

      post '/signin', params: params
      expect(flash[:warning]).to eq("Invalid email or password")
      expect(response).to render_template('new')
    end

    it "logs in the user with valid input" do
      params = {}
      params[:email] = User.find_by_id(1).email
      params[:password] = "password123"

      post '/signin', params: params
      expect(flash[:notice]).to eq("Logged in successfully")
      expect(response).to redirect_to '/'
    end

    it "logs in the user with valid input (and redirects back to the original URL)" do
      params = {}
      params[:email] = User.find_by_id(1).email
      params[:password] = "password123"
      params[:redirect_url] = "/dashboard"

      post '/signin', params: params
      expect(flash[:notice]).to eq("Logged in successfully")
      expect(response).to redirect_to '/dashboard'
    end

    it "renders new with bad password" do
      params = {}
      params[:email] = User.find_by_id(1).email
      params[:password] = "wrongpassword"

      post '/signin', params: params
      expect(flash[:warning]).to eq("Invalid email or password")
      expect(response).to render_template('new')
    end
  end

  describe "Log out user" do
    it "logs the user out" do
      params = {}
      params[:email] = "vn@columbia.edu"
      params[:password] = "password123"

      post '/signin', params: params

      get '/logout'

      expect(flash[:notice]).to eq("Logged Out")
      expect(response).to redirect_to '/'
    end

    it "logs the user out (and brings them back to the original URL if a referrer is present)" do
      params = {}
      params[:email] = "vn@columbia.edu"
      params[:password] = "password123"

      post '/signin', params: params
      get '/logout', headers: { 'HTTP_REFERER' => 'http://www.example.com/listing/1' }

      expect(flash[:notice]).to eq("Logged Out")
      expect(response).to redirect_to '/listing/1'
    end

    it "errors out if we never logged in" do
      get '/logout'

      expect(flash[:notice]).to eq("Cannot log out if you never logged in.")
      expect(response).to redirect_to '/'
    end
  end

end
