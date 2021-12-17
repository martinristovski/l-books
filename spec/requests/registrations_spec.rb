require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "GET /signup" do
    it "gets the signup page" do
      get '/signup'
      expect(response).to render_template 'new'
    end
  end

  describe "Create new user" do
    it "registers a new user" do
      params = {}
      params[:user] = {}
      params[:user][:email] = "test@columbia.edu"
      params[:user][:first_name] = "Test"
      params[:user][:last_name] = "Test"
      params[:user][:uni] = "tt1111"
      params[:user][:school] = "CC"
      params[:user][:password] = "passtest"
      params[:user][:password_confirmation] = "passtest"
      post '/signup', params: params
      
      expect(response).to redirect_to '/'
    end
  end

  describe "Receive non-columbia email" do
    it "returns new" do
      params = {}
      params[:user] = {}
      params[:user][:email] = "test@test.edu"
      params[:user][:first_name] = "Test"
      params[:user][:last_name] = "Test"
      params[:user][:uni] = "tt1111"
      params[:user][:school] = "CC"
      params[:user][:password] = "passtest"
      params[:user][:password_confirmation] = "wrongtext"
      post '/signup', params: params
      
      expect(response.response_code).to eq 200 
    end
  end

  describe "Receive bad password confirmation" do
    it "returns new" do
      params = {}
      params[:user] = {}
      params[:user][:email] = "test@test.edu"
      params[:user][:first_name] = "Test"
      params[:user][:last_name] = "Test"
      params[:user][:uni] = "tt1111"
      params[:user][:school] = "CC"
      params[:user][:password] = "passtest"
      params[:user][:password_confirmation] = "wrongtext"
      post '/signup', params: params
      
      expect(response.response_code).to eq 200 
    end
  end

end
