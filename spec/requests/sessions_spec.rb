require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "Go to sign in page" do
    it "renders the sign in page" do
      get '/signin'

      expect(response.body).to match("Sign In")
      expect(response.body).to match("Email:")
      expect(response.body).to match("Password:")
      expect(response.body).to match("Log In")
    end
  end

end
