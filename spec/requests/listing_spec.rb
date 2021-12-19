require 'rails_helper'

RSpec.describe "Listings", type: :request do
  # include necessary for file upload
  include ActionDispatch::TestProcess::FixtureFile

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

  describe "Delete listing while not signed in" do
    it "redirects to the sign in page" do
      get '/listing/1/delete'
      expect(response).to redirect_to('/signin')
    end
  end

  describe "Delete listing while signed in but not as the seller" do
    it "redirects to the home page with a message" do
      params = {:email => "ic@columbia.edu", :password => "password123"}
      post '/signin', params: params
      expect(session[:user_id]).to eq(2)

      get '/listing/1/delete'
      expect(response).to redirect_to('/')
      expect(flash[:notice]).to eq("Forbidden: Only the seller of a listing can delete that listing.")
    end
  end

  describe "Delete listing while signed in" do
    before :each do
      params = {:email => "vn@columbia.edu", :password => "password123"}
      post '/signin', params: params
      expect(session[:user_id]).to eq(1)
    end

    it "redirects to / if the listing doesn't exist" do
      delete '/listing/50/delete'
      expect(response).to redirect_to('/')
    end

    it "redirects to /search if the listing isn't created by the user trying to delete it" do
      delete '/listing/2/delete'
      expect(response).to redirect_to('/')
    end

    it "renders delete upon GET request" do
      get '/listing/1/delete'
      expect(response).to render_template('delete')
    end

    it "deletes listing" do
      delete '/listing/1/delete'
      expect(flash[:notice]).to eq("Listing deleted!")
      expect(response).to redirect_to('/')
    end
  end

  describe "Edit listing while not signed in" do
    it "redirects to the sign in page" do
      get '/listing/1/edit'
      expect(response).to redirect_to('/signin')
    end
  end

  describe "Edit listing while signed in" do
    before :all do
      l1 = Listing.create!(
        id: 1,
        book_id: 1,
        price: 5.00,
        condition: "Like new",
        description: "Copy of the Iliad. Looks like it was never used (which may or may not have been the case)...",
        seller_id: 1
      )
    end

    before :each do
      params = {:email => "vn@columbia.edu", :password => "password123"}
      post '/signin', params: params
      expect(session[:user_id]).to eq(1)
    end

    it "redirects to / if the listing doesn't exist" do
      post '/listing/0/edit'
      expect(flash[:notice]).to eq("Sorry, we couldn't find a listing with that ID.")
      expect(response).to redirect_to('/')
    end

    it "redirects to / if the listing isn't created by the user trying to edit it" do
      post '/listing/2/edit'
      expect(flash[:notice]).to eq("Forbidden: Only the seller of a listing can edit that listing.")
      expect(response).to redirect_to('/')
    end

    it "renders edit upon GET request" do
      get '/listing/1/edit'
      expect(response).to render_template('edit')
    end

    it "edits listing - invalid condition" do
      post '/listing/1/edit', params: {:condition => "", :course => "HUMA1001", :price => "5.50", :description => "lorem ipsum"}
      expect(flash[:notice]).to match "Please enter the book's condition."
      expect(response).to render_template('edit')
    end

    it "edits listing - blank price" do
      post '/listing/1/edit', params: {:condition => "a", :course => "HUMA1001", :price => "", :description => "lorem ipsum"}
      expect(flash[:notice]).to match "Please enter the book's price."
      expect(response).to render_template('edit')
    end

    it "edits listing - invalid price" do
      post '/listing/1/edit', params: {:condition => "a", :course => "HUMA1001", :price => "a", :description => "lorem ipsum"}
      expect(flash[:notice]).to match "The price you have entered is invalid."
      expect(response).to render_template('edit')
    end

    it "edits listing - invalid description" do
      post '/listing/1/edit', params: {:condition => "a", :course => "HUMA1001", :price => "5.50", :description => ""}
      expect(flash[:notice]).to match "Please enter a description for the book."
      expect(response).to render_template('edit')
    end

    it "edits listing" do
      pending 'TODO: FIX THIS'

      post '/listing/1/edit', params: {:condition => "a", :course => "HUMA1001", :price => "5.50", :description => "lorem ipsum"}
      expect(flash[:notice]).to eq("Listing updated!")
      expect(response).to redirect_to('/listing/1')
    end

    it "accepts a valid image as an upload and then allows deleting it" do
      params = {}
      params[:condition] = "Like new"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')

      post "/listing/1/edit/uploadimg", params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('edit')

      test__img_id = @controller.instance_variable_get(:@listing).listing_images[0].id

      # delete it now
      post "/listing/1/edit/deleteimg/#{test__img_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 5 slot(s) left.'
      expect(response).to render_template('edit')
    end

    it "doesn't accept a nil image" do
      params = {}
      params[:condition] = "Like new"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = nil

      post "/listing/1/edit/uploadimg", params: params
      expect(flash[:notice]).to include "You must upload at least one image."
      expect(response).to render_template('edit')
    end

    it "allows for uploading multiple images but no more than 5,
        allows for deleting (but only for known images),
        prevents submission without at least one image,
        and prevents uploading images >2MB" do
      params = {}
      params[:condition] = "Like new"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')

      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('edit')

      # img 2
      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 3 slot(s) left."
      expect(response).to render_template('edit')

      # img 3
      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 2 slot(s) left."
      expect(response).to render_template('edit')

      # img 4
      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 1 slot(s) left."
      expect(response).to render_template('edit')

      # img 5
      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have no more slots left."
      expect(response).to render_template('edit')

      # get img IDs
      img1_id = @controller.instance_variable_get(:@listing).listing_images[0].id
      img2_id = @controller.instance_variable_get(:@listing).listing_images[1].id
      img3_id = @controller.instance_variable_get(:@listing).listing_images[2].id
      img4_id = @controller.instance_variable_get(:@listing).listing_images[3].id
      img5_id = @controller.instance_variable_get(:@listing).listing_images[4].id

      # attempt to upload to a non-existent listing
      post '/listing/0/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Sorry, we couldn't find a listing with that ID."
      expect(response).to redirect_to('/')

      # attempt to upload a 6th image
      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to include "You have already uploaded the maximum of 5 images."
      expect(response).to render_template('edit')

      # delete img 5
      params[:image] = nil
      post "/listing/1/edit/deleteimg/#{img5_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 1 slot(s) left.'
      expect(response).to render_template('edit')

      # attempt to delete an image with a bad ID
      post "/listing/1/edit/deleteimg/0", params: params
      expect(flash[:notice]).to include 'The image in question could not be found.'
      expect(response).to render_template('edit')

      # delete img 4
      post "/listing/1/edit/deleteimg/#{img4_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 2 slot(s) left.'
      expect(response).to render_template('edit')

      # delete img 3
      post "/listing/1/edit/deleteimg/#{img3_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 3 slot(s) left.'
      expect(response).to render_template('edit')

      # delete img 4
      post "/listing/1/edit/deleteimg/#{img2_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 4 slot(s) left.'
      expect(response).to render_template('edit')

      # delete img 5
      post "/listing/1/edit/deleteimg/#{img1_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 5 slot(s) left.'
      expect(response).to render_template('edit')

      # attempt to delete from a non-existent listing
      post '/listing/0/edit/deleteimg/0', params: params
      expect(flash[:notice]).to match "Sorry, we couldn't find a listing with that ID."
      expect(response).to redirect_to('/')

      # attempt to upload an oversized image
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/oversized1.jpg", 'image/jpeg')
      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to include "The image you attempted to upload is too big."
      expect(response).to render_template('edit')

      # attempt to submit without any images
      post '/listing/1/edit', params: params
      expect(flash[:notice]).to include "You must upload at least one image."
      expect(response).to render_template('edit')
    end

    it "redirects to the sign-in page if we aren't logged in" do
      get '/logout' # logout first

      params = {}
      params[:condition] = "Like new"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = nil

      post '/listing/1/edit/uploadimg', params: params
      expect(response).to redirect_to('/signin')

      post "/listing/1/edit/deleteimg/0", params: params
      expect(response).to redirect_to('/signin')

      post '/listing/1/edit', params: params
      expect(response).to redirect_to('/signin')
    end

    it "errors out if the logged in user isn't the author of the listing" do
      # upload an image and edit the listing as vn@columbia.edy
      params = {}
      params[:condition] = "Like new"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')

      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('edit')

      # submit the edit!
      post '/listing/1/edit', params: params
      expect(flash[:notice]).to include "Listing updated!"
      expect(response).to redirect_to('/listing/1')

      # get the uploaded image's ID
      img_id = @controller.instance_variable_get(:@listing).listing_images[0].id

      # logout from vn's account
      get '/logout' # logout first

      # log in as another user -- ic@columbia.edu
      loginparams = {:email => "ic@columbia.edu", :password => "password123"}
      post '/signin', params: loginparams
      expect(session[:user_id]).to eq(2)

      # attempt to upload to the same draft listing
      post '/listing/1/edit/uploadimg', params: params
      expect(flash[:notice]).to match "Forbidden: Only the seller of a listing can edit that listing."
      expect(response).to redirect_to('/')

      # attempt to delete the image in that draft listing
      post "/listing/1/edit/deleteimg/#{img_id}", params: params
      expect(flash[:notice]).to match "Forbidden: Only the seller of a listing can edit that listing."
      expect(response).to redirect_to('/')

      # attempt to submit that draft listing for publication
      post '/listing/1/edit', params: params
      expect(flash[:notice]).to match "Forbidden: Only the seller of a listing can edit that listing."
      expect(response).to redirect_to('/')
    end
  end

  describe "Create new listing while not signed in" do
    it "redirects to the sign in page" do
      get '/listing/new'
      expect(response).to redirect_to('/signin')
    end
  end

  describe "Create new listing while signed in" do
    before :each do
      params = {:email => "vn@columbia.edu", :password => "password123"}
      post '/signin', params: params
      expect(session[:user_id]).to eq(1)
    end

    it "renders new on GET request" do
      get '/listing/new'
      expect(response).to render_template('new')
    end

    it "returns error for blank ISBN" do
      params = {}
      params[:isbn] = "" # THIS 
      params[:condition] = "Like new"
      params[:price] = "5.99"
      params[:course] = "HUMA1001"
      params[:description] = "In great condition, only used for one week."
      params[:hidden_expandisbn] = false
      post '/listing/new', params: params
      
      expect(flash[:notice]).to match "The ISBN is required."
    end

    it "returns error for invalid ISBN" do
      params = {}
      params[:isbn] = "1119781001100110" # THIS 
      params[:condition] = "Like new"
      params[:price] = "5.99"
      params[:course] = "HUMA1001"
      params[:description] = "In great condition, only used for one week."
      params[:hidden_expandisbn] = false
      post '/listing/new', params: params
      
      expect(flash[:notice]).to match "The ISBN you have entered is invalid."
    end

    it "returns error for blank condition" do
      params = {}
      params[:isbn] = "9781001100110"
      # params[:condition] = "" # THIS
      params[:price] = "5.99"
      params[:course] = "HUMA1001"
      params[:description] = "In great condition, only used for one week."
      params[:hidden_expandisbn] = false
      post '/listing/new', params: params
      
      expect(flash[:notice]).to match "Please enter the book's condition."
    end

    it "returns error for blank price" do
      params = {}
      params[:isbn] = "9781001100110"
      params[:condition] = "" 
      # params[:price] = nothing # THIS
      params[:course] = "HUMA1001"
      params[:description] = "In great condition, only used for one week."
      params[:hidden_expandisbn] = false
      post '/listing/new', params: params
      
      expect(flash[:notice]).to match "Please enter the book's price."
    end

    it "returns error for invalid price" do
      params = {}
      params[:isbn] = "9781001100110"
      params[:condition] = "a" 
      params[:price] = 3.12312313 # THIS
      params[:course] = "HUMA1001"
      params[:description] = "In great condition, only used for one week."
      params[:hidden_expandisbn] = false
      post '/listing/new', params: params
      
      expect(flash[:notice]).to match "The price you have entered is invalid."
    end

    it "returns error for blank description" do
      params = {}
      params[:isbn] = "9781001100110"
      params[:condition] = "a" 
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "" # THIS
      params[:hidden_expandisbn] = false
      post '/listing/new', params: params
      
      expect(flash[:notice]).to match "Please enter a description for the book."
    end

    it "asks for more info if hidden_expandisbn == true" do
      params = {}
      params[:isbn] = "9781001100110"
      params[:condition] = "a" 
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = false

      # upload image first
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('new')

      # test__img_id = @controller.instance_variable_get(:@listing).listing_images[0].id
      test__draft_listing_id = @controller.instance_variable_get(:@form_data)[:hidden_draft_listing_id]
      params[:hidden_draft_listing_id] = test__draft_listing_id

      # submit the listing
      post '/listing/new', params: params
      expect(flash[:notice]).to eq("Please enter more information about this book.")
      expect(response).to render_template('new')
    end

    it "correctly creates a listing for a book (whose info was obtained manually) that didn't already exist in the DB" do
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "a"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = true
      params[:book_title] = "Test Title"
      params[:book_authors] = "Test Authors"
      params[:book_edition] = "2nd"
      params[:book_publisher] = "Test Pub"
      params[:hidden__book_isbn] = "9780226470498"

      # upload image first
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('new')

      # test__img_id = @controller.instance_variable_get(:@listing).listing_images[0].id
      test__draft_listing_id = @controller.instance_variable_get(:@form_data)[:hidden_draft_listing_id]
      params[:hidden_draft_listing_id] = test__draft_listing_id

      # submit the listing
      post '/listing/new', params: params
      expect(flash[:notice]).to eq("Listing created!")
      expect(response).to redirect_to("/listing/#{test__draft_listing_id}")
      expect(@controller.instance_variable_get(:@listing).book.title).to eq("Test Title") # the title of the previously unknown book
    end

    it "correctly creates a listing for a book (whose info was obtained from the GBooks API) that didn't already exist in the DB" do
      params = {}
      params[:isbn] = "9780872203495"
      params[:condition] = "a"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = false

      # upload image first
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('new')

      # test__img_id = @controller.instance_variable_get(:@listing).listing_images[0].id
      test__draft_listing_id = @controller.instance_variable_get(:@form_data)[:hidden_draft_listing_id]
      params[:hidden_draft_listing_id] = test__draft_listing_id

      # submit the listing
      post '/listing/new', params: params
      expect(flash[:notice]).to eq("Listing created!")
      expect(response).to redirect_to("/listing/#{test__draft_listing_id}")
      expect(@controller.instance_variable_get(:@listing).book.title).to eq("Complete Works") # the title of the previously unknown book
    end

    it "returns error for missing book title" do
      params = {}
      params[:isbn] = "9781001100110"
      params[:condition] = "a" 
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:hidden_expandisbn] = true
      params[:book_title] = "" # THIS
      params[:book_authors] = "B"
      params[:book_edition] = "C"
      params[:book_publisher] = "D"
      params[:book_isbn] = params[:isbn]

      post '/listing/new', params: params
      expect(flash[:notice]).to match "Please enter the unknown book's title."
      expect(response).to render_template('new')
    end

    it "returns error for missing authors" do
      params = {}
      params[:isbn] = "9781001100110"
      params[:condition] = "a" 
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:hidden_expandisbn] = true
      params[:book_title] = "A" 
      params[:book_authors] = "" # THIS
      params[:book_edition] = "C"
      params[:book_publisher] = "D"
      params[:book_isbn] = params[:isbn]

      post '/listing/new', params: params
      expect(flash[:notice]).to match "Please enter the unknown book's author list."
      expect(response).to render_template('new')
    end

    it "returns error for missing publisher" do
      params = {}
      params[:isbn] = "9781001100110"
      params[:condition] = "a" 
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:hidden_expandisbn] = true
      params[:book_title] = "A" 
      params[:book_authors] = "B"
      params[:book_edition] = "C"
      params[:book_publisher] = "" # THIS
      params[:book_isbn] = params[:isbn]

      post '/listing/new', params: params
      expect(flash[:notice]).to match "Please enter the unknown book's publisher."
      expect(response).to render_template('new')
    end

    it "accepts a valid image as an upload and then allows deleting it" do
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = false

      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('new')

      test__img_id = @controller.instance_variable_get(:@listing).listing_images[0].id
      test__draft_listing_id = @controller.instance_variable_get(:@form_data)[:hidden_draft_listing_id]

      # delete it now
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = nil
      params[:hidden_expandisbn] = false
      params[:hidden_draft_listing_id] = test__draft_listing_id

      post "/listing/new/deleteimg/#{test__img_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 5 slot(s) left.'
      expect(response).to render_template('new')
    end

    it "accepts a valid image as an upload and then allows deleting it (WITH hidden_expandisbn as true)" do
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = true
      params[:book_title] = "Test Title"
      params[:book_authors] = "Test Authors"
      params[:book_edition] = "2nd"
      params[:book_publisher] = "Test Pub"
      params[:hidden__book_isbn] = "9780226470498"

      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('new')

      test__img_id = @controller.instance_variable_get(:@listing).listing_images[0].id
      test__draft_listing_id = @controller.instance_variable_get(:@form_data)[:hidden_draft_listing_id]

      # delete it now
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = nil
      params[:hidden_expandisbn] = true
      params[:book_title] = "Test Title"
      params[:book_authors] = "Test Authors"
      params[:book_edition] = "2nd"
      params[:book_publisher] = "Test Pub"
      params[:hidden__book_isbn] = "9780226470498"
      params[:hidden_draft_listing_id] = test__draft_listing_id

      post "/listing/new/deleteimg/#{test__img_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 5 slot(s) left.'
      expect(response).to render_template('new')
    end

    it "doesn't accept a nil image" do
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = nil
      params[:hidden_expandisbn] = false

      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to include "You must upload at least one image."
      expect(response).to render_template('new')
    end

    it "allows for uploading multiple images but no more than 5,
        allows for deleting (but only for known images),
        prevents submission without at least one image,
        and prevents uploading images >2MB" do
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = false

      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('new')

      params[:hidden_draft_listing_id] = @controller.instance_variable_get(:@form_data)[:hidden_draft_listing_id]

      # img 2
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 3 slot(s) left."
      expect(response).to render_template('new')

      # img 3
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 2 slot(s) left."
      expect(response).to render_template('new')

      # img 4
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 1 slot(s) left."
      expect(response).to render_template('new')

      # img 5
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have no more slots left."
      expect(response).to render_template('new')

      # get img IDs
      img1_id = @controller.instance_variable_get(:@listing).listing_images[0].id
      img2_id = @controller.instance_variable_get(:@listing).listing_images[1].id
      img3_id = @controller.instance_variable_get(:@listing).listing_images[2].id
      img4_id = @controller.instance_variable_get(:@listing).listing_images[3].id
      img5_id = @controller.instance_variable_get(:@listing).listing_images[4].id

      # attempt to upload a 6th image
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to include "You have already uploaded the maximum of 5 images."
      expect(response).to render_template('new')

      # delete img 5
      params[:image] = nil
      post "/listing/new/deleteimg/#{img5_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 1 slot(s) left.'
      expect(response).to render_template('new')

      # attempt to delete an image with a bad ID
      post "/listing/new/deleteimg/0", params: params
      expect(flash[:notice]).to include 'The image in question could not be found.'
      expect(response).to render_template('new')

      # delete img 4
      post "/listing/new/deleteimg/#{img4_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 2 slot(s) left.'
      expect(response).to render_template('new')

      # delete img 3
      post "/listing/new/deleteimg/#{img3_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 3 slot(s) left.'
      expect(response).to render_template('new')

      # delete img 4
      post "/listing/new/deleteimg/#{img2_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 4 slot(s) left.'
      expect(response).to render_template('new')

      # delete img 5
      post "/listing/new/deleteimg/#{img1_id}", params: params
      expect(flash[:notice]).to match 'Image deleted. You have 5 slot(s) left.'
      expect(response).to render_template('new')

      # attempt to upload an oversized image
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/oversized1.jpg", 'image/jpeg')
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to include "The image you attempted to upload is too big."
      expect(response).to render_template('new')

      # attempt to submit without any images
      post '/listing/new', params: params
      expect(flash[:notice]).to include "You must upload at least one image."
      expect(response).to render_template('new')
    end

    it "redirects to the sign-in page if we aren't logged in" do
      get '/logout' # logout first

      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = nil
      params[:hidden_expandisbn] = false

      post '/listing/new/uploadimg', params: params
      expect(response).to redirect_to('/signin')

      post "/listing/new/deleteimg/0", params: params
      expect(response).to redirect_to('/signin')

      post '/listing/new', params: params
      expect(response).to redirect_to('/signin')
    end

    it "errors out if the logged in user isn't the author of the draft listing" do
      # upload as vn@columbia.edy
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = false

      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "Image uploaded. You have 4 slot(s) left."
      expect(response).to render_template('new')

      params[:hidden_draft_listing_id] = @controller.instance_variable_get(:@form_data)[:hidden_draft_listing_id]
      img_id = @controller.instance_variable_get(:@listing).listing_images[0].id

      # logout from vn's account
      get '/logout' # logout first

      # log in as another user -- ic@columbia.edu
      loginparams = {:email => "ic@columbia.edu", :password => "password123"}
      post '/signin', params: loginparams
      expect(session[:user_id]).to eq(2)

      # attempt to upload to the same draft listing
      post '/listing/new/uploadimg', params: params
      expect(flash[:notice]).to match "You are not authorized to do this."
      expect(response).to redirect_to('/')

      # attempt to delete the image in that draft listing
      post "/listing/new/deleteimg/#{img_id}", params: params
      expect(flash[:notice]).to include "You are not authorized to do this."

      # attempt to submit that draft listing for publication
      post '/listing/new', params: params
      expect(flash[:notice]).to match "You are not authorized to do this."
      expect(response).to redirect_to('/')
    end

    it "errors out if we attempt to call deleteimg when a draft listing has not yet been created" do
      # upload as vn@columbia.edy
      params = {}
      params[:isbn] = "9780226470498"
      params[:condition] = "Good"
      params[:price] = "3.12"
      params[:course] = "HUMA1001"
      params[:description] = "Lorem ipsum."
      params[:image] = fixture_file_upload("#{Rails.root}/spec/fixtures/files/plato1.jpg", 'image/jpeg')
      params[:hidden_expandisbn] = false

      # attempt to delete the image in that draft listing
      post "/listing/new/deleteimg/1", params: params
      expect(flash[:notice]).to include "Draft listing missing."
    end
  end

  describe "Handle marking listings as sold" do # TODO
    before :each do
      params = {:email => "vn@columbia.edu", :password => "password123"}
      post '/signin', params: params
      expect(session[:user_id]).to eq(1)
      expect(flash[:notice]).to eq("Logged in successfully")
    end

    it "renders sold page" do
      get '/listing/1/sold'
      expect(response).to render_template('sold')
    end

    it "says there's no such listing for invalid listing id" do
      post "/listing/0/sold"
      expect(flash[:notice]).to eq("Sorry, we couldn't find a listing with that ID.")
    end

    it "asks for valid email if given invalid buyer email" do
      params = {:user_email => "XXXXXXXXXXXic@columbia.edu", :amount => "5.5"}
      post "/listing/1/sold", params: params
      expect(flash[:warning]).to eq('Please enter a valid email.')
    end
    
    it "marks listing as sold" do
      params = {:user_email => "ic@columbia.edu", :amount => "5.5"}
      post "/listing/1/sold", params: params
      expect(flash[:success]).to eq("Listing updated!")
      expect(response).to redirect_to('/listing/1')
    end

    it "gets the listing show page for a sold listing" do
      get "/listing/1"
      expect(flash[:notice]).to eq("This listing has been marked as SOLD!")
    end
  end
end
