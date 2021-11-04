require 'rails_helper'

RSpec.describe "Books", type: :request do
  before(:all) do
    # from seed file
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
  end

  describe "GET /book/1" do
    it "renders book listing template for an existing book" do
      get '/book/1'
      expect(response).to render_template('show')
    end
  end

  describe "GET /book/0" do
    it "redirect home for a non-existing book" do
      get '/book/0'
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Sorry, we couldn't find a book with that ID.")
    end
  end

  describe "GET /book/dekoewd" do
    it "redirect home if non-numeric id given" do
      get '/book/dekoewd'
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Sorry, we couldn't find a book with that ID.")
    end
  end

  describe "GET /book/" do
    it "redirect home if no id given" do
      get '/book/'
      expect(response).to redirect_to('/')
    end
  end

end
