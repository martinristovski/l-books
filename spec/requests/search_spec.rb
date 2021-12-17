require 'rails_helper'

RSpec.describe "Searches", type: :request do
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

  describe "GET /" do
    it "renders the home page properly" do
      get '/'
      expect(response).to render_template('index')

      assigns(:search_types).each do |st|
        expect(st).to respond_to(:id)
        expect( %w[titleauthor course isbn]).to include(st.id)
      end
    end
  end

  describe "GET /search" do
    it "renders the home page because the search was invalid" do
      get '/search'
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Invalid search.")
    end
  end

  describe "GET /search with invalid parameters" do
    it "renders the home page because the commit param was not correct" do
      params = {:commit => "DontGo", :criteria => "titleauthor", :search_term => "Iliad"}
      get '/search', params: params
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Invalid search.")
    end

    it "renders the home page because the criteria param was empty" do
      params = {:commit => "Go", :criteria => "", :search_term => "Iliad"}
      get '/search', params: params
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Invalid search.")
    end

    it "renders the home page because the criteria param was not valid" do
      params = {:commit => "Go", :criteria => "sadasdhk", :search_term => "Iliad"}
      get '/search', params: params
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Invalid search.")
    end

    it "renders the home page because the search param was empty" do
      params = {:commit => "Go", :criteria => "titleauthor", :search_term => ""}
      get '/search', params: params
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Please enter a search term.")
    end
  end

  describe "GET /search with valid parameters" do
    it "searches by title" do
      params = {:commit => "Go", :criteria => "titleauthor", :search_term => "Iliad"}
      get '/search', params: params
      expect(response).to render_template('results')

      # make sure that the iliad is the only book shown
      expect(assigns(:results).find { |r| r.title == "The Iliad of Homer" }).to_not be_nil
      expect(assigns(:results).find { |r| r.title == "Plato Symposium (Hackett Classics)" }).to be_nil
      expect(assigns(:results).find { |r| r.title == "The Aeneid of Virgil (Bantam Classics)" }).to be_nil
    end

    it "searches by author" do
      params = {:commit => "Go", :criteria => "titleauthor", :search_term => "Homer"}
      get '/search', params: params
      expect(response).to render_template('results')

      # make sure that the iliad is the only book shown
      expect(assigns(:results).find { |r| r.authors == "Richmond Lattimore; Homer" }).to_not be_nil
      expect(assigns(:results).find { |r| r.authors == "Plato; Alexander Nehamas; Paul Woodruff" }).to be_nil
      expect(assigns(:results).find { |r| r.authors == "Virgil; Allen Mandelbaum" }).to be_nil
    end

    it "searches by course number" do
      params = {:commit => "Go", :criteria => "course", :search_term => "HUMA1001"}
      get '/search', params: params
      expect(response).to render_template('results')

      # make sure that the iliad is the only book shown
      expect(assigns(:results).find { |r| r.title == "The Iliad of Homer" }).to_not be_nil
      expect(assigns(:results).find { |r| r.title == "Plato Symposium (Hackett Classics)" }).to_not be_nil
      expect(assigns(:results).find { |r| r.title == "The Aeneid of Virgil (Bantam Classics)" }).to_not be_nil
    end

    it "searches by ISBN" do
      params = {:commit => "Go", :criteria => "isbn", :search_term => "9780872200760"}
      get '/search', params: params
      expect(response).to render_template('results')

      # make sure that the iliad is the only book shown
      expect(assigns(:results).find { |r| r.title == "The Iliad of Homer" }).to be_nil
      expect(assigns(:results).find { |r| r.title == "Plato Symposium (Hackett Classics)" }).to_not be_nil
      expect(assigns(:results).find { |r| r.title == "The Aeneid of Virgil (Bantam Classics)" }).to be_nil
    end

    it "searches but gets no results (isbn or title/author)" do
      params = {:commit => "Go", :criteria => "isbn", :search_term => "43728468372"}
      get '/search', params: params
      expect(response).to render_template('results')
      expect(assigns(:results)).to be_empty
    end

    it "searches but gets no results (non-existent course)" do
      params = {:commit => "Go", :criteria => "course", :search_term => "coms4995"}
      get '/search', params: params
      expect(response).to render_template('results')
      expect(assigns(:results)).to be_empty
    end
  end
end
