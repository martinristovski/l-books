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
      expect(flash[:notice]).to eq("Invalid email or password")
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

    it "renders new with bad password" do
      params = {}
      params[:email] = User.find_by_id(1).email
      params[:password] = "wrongpassword"

      post '/signin', params: params
      expect(flash[:notice]).to eq("Invalid email or password")
      expect(response).to render_template('new')
    end
  end

  describe "Log out user" do
    it "logs the user out" do
      params = {}
      params[:email] = "fake@email.com"
      params[:password] = "loremipsum"

      post '/signin', params: params

      get '/logout'

      expect(flash[:notice]).to eq("Logged Out")
      expect(response).to redirect_to '/'
    end
  end

end
