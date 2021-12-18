require "down"

class ListingController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'other_pages'

  def show
    listing_id = params[:id]
    @listing = Listing.find_by_id(listing_id)

    if @listing.nil? or @listing.status == "draft"
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
      return
    end

    if @listing.status == "sold"
      flash[:notice] = "This listing has been marked as SOLD!"
    end

    if session[:user_id] != nil
      @existing_bookmark = ListingBookmark.find_by(listing_id: listing_id, user_id: session[:user_id])
    end
  end

  def sold
    listing_id = params[:id]
    begin
      listing_in_question = Listing.find(listing_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "listing", action: 'index'
      return
    end

    @listing = listing_in_question
    
    if request.get?
      render 'sold', layout: 'other_pages'
    elsif request.post?
      @form_data = {
        :user_email => params[:user_email],
        :amount => params[:amount]
      }

      user = User.find_by(email: @form_data[:user_email])

      if user.nil?
          flash[:warning] = 'Please enter a valid email.'
          @listing = listing_in_question
          redirect_to controller: "listing", action: 'sold'
          return
      end

      @listing.status = 'sold'
      @listing.save!

      flash[:notice] = "Listing updated!"
      redirect_to "/listing/#{listing_in_question.id}"
    end
  end


  def delete
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # get the listing in question
    listing_id = params[:id]
    begin
      listing_in_question = Listing.find(listing_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
      return
    end

    # only allow the seller to edit their own listing
    if session[:user_id] != listing_in_question.seller.id
      flash[:notice] = "Forbidden: Only the seller of a listing can delete that listing."
      redirect_to controller: "search", action: 'index'
      return
    end

    if request.get?
      @listing = listing_in_question
      render 'delete', layout: 'other_pages'
    elsif request.delete?
      listing_in_question.destroy
      flash[:notice] = "Listing deleted!"
      redirect_to controller: "search", action: 'index'
    end
  end

  def edit__delete_uploaded_image
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # get the listing in question
    listing_id = params[:id]
    begin
      listing_in_question = Listing.find(listing_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
      return
    end

    # only allow the seller to edit their own listing
    if session[:user_id] != listing_in_question.seller.id
      flash[:notice] = "Forbidden: Only the seller of a listing can edit that listing."
      redirect_to controller: "search", action: 'index'
      return
    end

    @listing = listing_in_question
    @book = listing_in_question.book

    # store form info in a hash in case we need to return back to the form
    @form_data = {
      :condition => params[:condition],
      :price => params[:price],
      :course => params[:course], # TODO
      :description => params[:description],
      :image => params[:image]
    }

    # some error checks
    all_errors = []
    to_delete_img = params[:imgid]
    limg = ListingImage.find_by_id(to_delete_img)

    if limg.nil?
      all_errors.append("The image in question could not be found.")
    else
      limg.destroy
    end

    # print a single flash notice message on errors
    unless all_errors.empty?
      result = ""
      for err in all_errors do
        result += "<li>#{err}</li>"
      end
      flash[:notice] = "We encountered the following errors:<ul>#{result}</ul>".html_safe
      render 'edit', layout: 'other_pages'
      return
    end

    # check how many images we have uploaded
    flash[:notice] = "Image deleted. You have #{Listing.class_variable_get(:@@MAX_IMAGES) - @listing.listing_images.count} slot(s) left."
    render 'edit', layout: 'other_pages'
    # return
  end

  def edit__upload_image
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # get the listing in question
    listing_id = params[:id]
    begin
      listing_in_question = Listing.find(listing_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
      return
    end

    # only allow the seller to edit their own listing
    if session[:user_id] != listing_in_question.seller.id
      flash[:notice] = "Forbidden: Only the seller of a listing can edit that listing."
      redirect_to controller: "search", action: 'index'
      return
    end

    @listing = listing_in_question
    @book = listing_in_question.book

    # store form info in a hash in case we need to return back to the form
    @form_data = {
      :condition => params[:condition],
      :price => params[:price],
      :course => params[:course], # TODO
      :description => params[:description],
      :image => params[:image]
    }

    # some error checks
    all_errors = []

    # error check: no image was uploaded
    if @form_data[:image].nil?
      all_errors.append("You must upload at least one image.")
    end

    # error check: the image is over 2 MB in size
    if not @form_data[:image].nil? and @form_data[:image].size > 2000000
      all_errors.append("The image you attempted to upload is too big. Max allowed size: 2 MB. Your image: #{sprintf("%.2f MB", bytes_to_megabytes(@form_data[:image].size))}")
    end

    # error check: max number of images uploaded
    if @listing.listing_images.count == Listing.class_variable_get(:@@MAX_IMAGES)
      all_errors.append("You have already uploaded the maximum of #{Listing.class_variable_get(:@@MAX_IMAGES)} images.")
    end

    # print a single flash notice message on errors
    unless all_errors.empty?
      result = ""
      for err in all_errors do
        result += "<li>#{err}</li>"
      end
      flash[:notice] = "We encountered the following errors:<ul>#{result}</ul>".html_safe
      render 'edit', layout: 'other_pages'
      return
    end

    # else proceed to upload
    # upload the image
    image_name_id = ListingImage.generate_unique_name + File.extname(@form_data[:image].original_filename)
    S3FileHelper.upload_file(image_name_id, @form_data[:image])

    # add the DB entry
    ListingImage.create!(
      image_id: image_name_id,
      listing_id: @listing.id
    )

    # check how many images we have uploaded
    if @listing.listing_images.count == Listing.class_variable_get(:@@MAX_IMAGES)
      notice = "Image uploaded. You have no more slots left."
    else
      notice = "Image uploaded. You have #{Listing.class_variable_get(:@@MAX_IMAGES) - @listing.listing_images.count} slot(s) left."
    end

    flash[:notice] = notice
    render 'edit', layout: 'other_pages'
    # return
  end

  def edit
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # get the listing in question
    listing_id = params[:id]
    begin
      listing_in_question = Listing.find(listing_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
      return
    end

    # only allow the seller to edit their own listing
    if session[:user_id] != listing_in_question.seller.id
      flash[:notice] = "Forbidden: Only the seller of a listing can edit that listing."
      redirect_to controller: "search", action: 'index'
      return
    end

    @listing = listing_in_question
    @book = listing_in_question.book

    if request.get?
      @form_data = {
        :condition => listing_in_question.condition,
        :price => sprintf('%.2f', listing_in_question.price),  # convert to a string to 2 decimal places
        :course => "", # TODO
        :description => listing_in_question.description,
        :hidden_draft_listing_id => listing_in_question.id
      }
      @listing = listing_in_question

      flash[:notice] = nil
      render 'edit', layout: 'other_pages'

    elsif request.post?
      @form_data = {
        :condition => params[:condition],
        :price => params[:price],
        :course => params[:course], # TODO
        :description => params[:description]
      }

      # some simple error checks
      all_errors = []
      price_blank = false

      # error check: the condition is blank
      if @form_data[:condition].nil? or @form_data[:condition].empty?
        all_errors.append("Please enter the book's condition.")
      end

      # error check: the price is blank
      if @form_data[:price].nil? or @form_data[:price].empty?
        price_blank = true
        all_errors.append("Please enter the book's price.")
      end

      # error check: the course code is in the wrong format
      unless @form_data[:course].match /([A-Za-z][A-Za-z][A-Za-z][A-Za-z])([0-9][0-9][0-9][0-9])/
        all_errors.append("Invalid course code. Please use correct input form (E.g. 'HUMA1001').")
      end

      # error check (not performed if the price is blank): the price is not a decimal/float or is not positive or has more than 2 numbers after the decimal
      if not price_blank and
        ((false if Float(@form_data[:price]) rescue true) \
         or @form_data[:price].to_f < 0 \
         or (@form_data[:price].split('.').length > 1 and @form_data[:price].split('.')[1].length != 2))
        all_errors.append("The price you have entered is invalid.")
      end

      # error check: the description is blank
      if @form_data[:description].nil? or @form_data[:description].empty?
        all_errors.append("Please enter a description for the book.")
      end

      # error check: no images were uploaded
      if @listing.listing_images.count == 0
        all_errors.append("You must upload at least one image.")
      end

      # print a single flash notice message on errors
      unless all_errors.empty?
        result = ""
        for err in all_errors do
          result += "<li>#{err}</li>"
        end
        flash[:notice] = "We encountered the following errors:<ul>#{result}</ul>".html_safe
        render 'edit', layout: 'other_pages'
        return
      end

      listing_in_question.update(
        condition: @form_data[:condition],
        price: @form_data[:price],
        description: @form_data[:description],
      )

      flash[:notice] = "Listing updated!"
      redirect_to "/listing/#{listing_in_question.id}"
    end

  end

  def new__delete_uploaded_image
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # store form info in a hash in case we need to return back to the form
    @form_data = {
      :isbn => params[:isbn].tr('^0-9', ''),  # sanitize
      :condition => params[:condition],
      :price => params[:price],
      :course => params[:course],
      :description => params[:description],
      :hidden_expandisbn => params[:hidden_expandisbn],
      :hidden_draft_listing_id => params[:hidden_draft_listing_id],

      :image => params[:image]
    }

    if @form_data[:hidden_expandisbn] == "true"
      extra_grabbed_info = {
        :book_title => params[:book_title],
        :book_authors => params[:book_authors],
        :book_edition => params[:book_edition],
        :book_publisher => params[:book_publisher],
        :hidden__book_isbn => params[:hidden__book_isbn]
      }
      @form_data = @form_data.merge(extra_grabbed_info)
    end

    if is_integer? params[:hidden_draft_listing_id]
      @form_data[:hidden_draft_listing_id] = params[:hidden_draft_listing_id].to_i
    else
      @form_data[:hidden_draft_listing_id] = -1
    end

    # some error checks
    all_errors = []
    to_delete_img = params[:imgid]

    if @form_data[:hidden_draft_listing_id] < 0
      all_errors.append("Draft listing missing.")
    else
      @listing = Listing.find_by_id(@form_data[:hidden_draft_listing_id])
      limg = ListingImage.find_by_id(to_delete_img)

      if limg.nil?
        all_errors.append("The image in question could not be found.")
      else
        if @listing.seller_id != session[:user_id]
          all_errors.append("You are not authorized to do this.")
        else
          limg.destroy
        end
      end
    end

    # print a single flash notice message on errors
    unless all_errors.empty?
      result = ""
      for err in all_errors do
        result += "<li>#{err}</li>"
      end
      flash[:notice] = "We encountered the following errors:<ul>#{result}</ul>".html_safe
      render 'new', layout: 'other_pages'
      return
    end

    # check how many images we have uploaded
    @listing = Listing.find_by_id(@form_data[:hidden_draft_listing_id])
    flash[:notice] = "Image deleted. You have #{Listing.class_variable_get(:@@MAX_IMAGES) - @listing.listing_images.count} slot(s) left."
    render 'new', layout: 'other_pages'
    # return
  end

  def new__upload_image
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # store form info in a hash in case we need to return back to the form
    @form_data = {
      :isbn => params[:isbn].tr('^0-9', ''),  # sanitize
      :condition => params[:condition],
      :price => params[:price],
      :course => params[:course],
      :description => params[:description],
      :hidden_expandisbn => params[:hidden_expandisbn],

      :image => params[:image]
    }

    if is_integer? params[:hidden_draft_listing_id]
      @form_data[:hidden_draft_listing_id] = params[:hidden_draft_listing_id].to_i
    else
      @form_data[:hidden_draft_listing_id] = -1
    end

    if @form_data[:hidden_expandisbn] == "true"
      extra_grabbed_info = {
        :book_title => params[:book_title],
        :book_authors => params[:book_authors],
        :book_edition => params[:book_edition],
        :book_publisher => params[:book_publisher],
        :hidden__book_isbn => params[:hidden__book_isbn]
      }
      @form_data = @form_data.merge(extra_grabbed_info)
    end

    # some error checks
    all_errors = []

    # error check: no image was uploaded
    if @form_data[:image].nil?
      all_errors.append("You must upload at least one image.")
    end

    # error check: the image is over 2 MB in size
    if not @form_data[:image].nil? and @form_data[:image].size > 2000000
      all_errors.append("The image you attempted to upload is too big. Max allowed size: 2 MB. Your image: #{sprintf("%.2f MB", bytes_to_megabytes(@form_data[:image].size))}")
    end

    # error check: max number of images uploaded
    if @form_data[:hidden_draft_listing_id] >= 0
      @listing = Listing.find_by_id(@form_data[:hidden_draft_listing_id])
      if @listing.nil?
        @form_data[:hidden_draft_listing_id] = -1
      else
        if @listing.listing_images.count == Listing.class_variable_get(:@@MAX_IMAGES)
          all_errors.append("You have already uploaded the maximum of #{Listing.class_variable_get(:@@MAX_IMAGES)} images.")
        end
      end
    end

    # print a single flash notice message on errors
    unless all_errors.empty?
      result = ""
      for err in all_errors do
        result += "<li>#{err}</li>"
      end
      flash[:notice] = "We encountered the following errors:<ul>#{result}</ul>".html_safe
      render 'new', layout: 'other_pages'
      return
    end

    # else proceed to upload | need to associate with draft listing

    if @form_data[:hidden_draft_listing_id] < 0
      # this means that we do not yet have a draft listing set yp -- create one
      id_to_use = Listing.maximum(:id).next
      Listing.create!(
        id: id_to_use,
        seller_id: session[:user_id],
        status: 'draft',
        book_id: nil
      )
      @form_data[:hidden_draft_listing_id] = id_to_use
    end

    # get the existing listing
    @listing = Listing.find_by_id(@form_data[:hidden_draft_listing_id])

    # error check: the user id does not match the seller id on the draft listing (abort completely)
    if @listing.seller_id != session[:user_id]
      flash[:notice] = "You are not authorized to do this."
      redirect_to controller: "search", action: 'index'
      return
    end

    # upload the image
    image_name_id = ListingImage.generate_unique_name + File.extname(@form_data[:image].original_filename)
    S3FileHelper.upload_file(image_name_id, @form_data[:image])

    # add the DB entry
    ListingImage.create!(
      image_id: image_name_id,
      listing_id: @form_data[:hidden_draft_listing_id]
    )

    # check how many images we have uploaded
    if @listing.listing_images.count == Listing.class_variable_get(:@@MAX_IMAGES)
      notice = "Image uploaded. You have no more slots left."
    else
      notice = "Image uploaded. You have #{Listing.class_variable_get(:@@MAX_IMAGES) - @listing.listing_images.count} slot(s) left."
    end

    flash[:notice] = notice
    render 'new', layout: 'other_pages'
    # return
  end

  def new__finalize
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # store form info in a hash in case we need to return back to the form
    @form_data = {
      :isbn => params[:isbn].tr('^0-9', ''),  # sanitize
      :condition => params[:condition],
      :price => params[:price],
      :course => params[:course],
      :description => params[:description],
      :hidden_expandisbn => params[:hidden_expandisbn],

      :image1 => params[:image]
    }

    if is_integer? params[:hidden_draft_listing_id]
      @form_data[:hidden_draft_listing_id] = params[:hidden_draft_listing_id].to_i
    else
      @form_data[:hidden_draft_listing_id] = -1
    end

    # some simple error checks
    all_errors = []
    isbn_blank = false
    price_blank = false

    # error check: the ISBN is blank
    if @form_data[:isbn].nil? or @form_data[:isbn].empty?
      isbn_blank = true
      all_errors.append("The ISBN is required.")
    end

    # error check (not performed if the ISBN is blank): the ISBN is not a number or is not 13 digits
    if not isbn_blank and (@form_data[:isbn].to_i.to_s != @form_data[:isbn] or @form_data[:isbn].to_i < 1000000000000 or @form_data[:isbn].to_i > 9999999999999)
      all_errors.append("The ISBN you have entered is invalid.")
    end

    # error check: the condition is blank
    if @form_data[:condition].nil? or @form_data[:condition].empty?
      all_errors.append("Please enter the book's condition.")
    end

    # error check: the price is blank
    if @form_data[:price].nil? or @form_data[:price].empty?
      price_blank = true
      all_errors.append("Please enter the book's price.")
    end

    # error check (not performed if the price is blank): the price is not a decimal/float or is not positive or has more than 2 numbers after the decimal
    if not price_blank and
      ((false if Float(@form_data[:price]) rescue true) \
         or @form_data[:price].to_f < 0 \
         or (@form_data[:price].split('.').length > 1 and @form_data[:price].split('.')[1].length != 2))
      all_errors.append("The price you have entered is invalid.")
    end

    # error check: the description is blank
    if @form_data[:description].nil? or @form_data[:description].empty?
      all_errors.append("Please enter a description for the book.")
    end

    # error check: the course code is in the wrong format
    unless @form_data[:course].match /([A-Za-z][A-Za-z][A-Za-z][A-Za-z])([0-9][0-9][0-9][0-9])/
      all_errors.append("Invalid course code. Please use correct input form (E.g. 'HUMA1001').")
    end

    # error check: no images were uploaded
    #   * either there's no draft listing which indicates that an upload was not attempted
    #   * OR the draft listing has no images attached
    if @form_data[:hidden_draft_listing_id] < 0
      all_errors.append("You must upload at least one image.")
    else
      @listing = Listing.find_by_id(@form_data[:hidden_draft_listing_id])
      if @listing.listing_images.count == 0
        all_errors.append("You must upload at least one image.")
      end

      # error check: the user id does not match the seller id on the draft listing (abort completely)
      if @listing.seller_id != session[:user_id]
        flash[:notice] = "You are not authorized to do this."
        redirect_to controller: "search", action: 'index'
        return
      end
    end

    # take extra fields into account if the form had them
    if @form_data[:hidden_expandisbn] == "true"
      extra_grabbed_info = {
        :book_title => params[:book_title],
        :book_authors => params[:book_authors],
        :book_edition => params[:book_edition],
        :book_publisher => params[:book_publisher],
        :hidden__book_isbn => params[:hidden__book_isbn]
      }
      @form_data = @form_data.merge(extra_grabbed_info)

      if @form_data[:book_title].nil? or @form_data[:book_title].empty?
        all_errors.append("Please enter the unknown book's title.")
      end

      if @form_data[:book_authors].nil? or @form_data[:book_authors].empty?
        all_errors.append("Please enter the unknown book's author list.")
      end

      if @form_data[:book_publisher].nil? or @form_data[:book_publisher].empty?
        all_errors.append("Please enter the unknown book's publisher.")
      end

      @form_data[:isbn] = @form_data[:hidden__book_isbn]
      # NOTE: edition is optional
    end

    # print a single flash notice message on errors
    unless all_errors.empty?
      result = ""
      for err in all_errors do
        result += "<li>#{err}</li>"
      end
      flash[:notice] = "We encountered the following errors:<ul>#{result}</ul>".html_safe
      render 'new', layout: 'other_pages'
      return
    end

    # search for this ISBN
    books_with_isbn = Book.where(isbn: @form_data[:isbn]).to_a
    book_autocreated = false

    # if book with isbn not found, return the lengthened form or populate using Google Books API
    if books_with_isbn.empty? and @form_data[:hidden_expandisbn] == "false"
      @form_data[:hidden_expandisbn] = true

      books_match = GoogleBooks.search('isbn:' + @form_data[:isbn], {:api_key => ENV["GBOOKS_API_KEY"]}) #returns collection of books that match the isbn
      book_match = books_match.first

      if book_match.nil?
        # if there was no match for the book, have the user manually input information
        flash[:notice] = "Please enter more information about this book."
        extra_book_info = {
          :book_title => "",
          :book_authors => "",
          :book_edition => "",
          :book_publisher => "",
          :hidden__book_isbn => @form_data[:isbn]
        }
        @form_data = @form_data.merge(extra_book_info)  # add extra fields
        # TODO: Could render a different template here for the longer form.
        render 'new', layout: 'other_pages'
        return
      else
        # else if we found a match on Google Books, use that info to autocreate a new book
        img_file = Down.download(book_match.image_link(:zoom => 2))
        if img_file.size > 0
          file_name_on_s3 = ListingImage.generate_unique_name
          S3FileHelper.upload_file(file_name_on_s3, img_file)
        else
          file_name_on_s3 = nil
        end

        # extra_book_info = {
        #   :book_title => book_match.title,
        #   :book_authors => book_match.authors,
        #   :book_edition => "", # make this optional
        #   :book_publisher => book_match.publisher,
        #   # add image to s3, using book_match.image_link(:zoom => 2) for a medium sized image
        #   :hidden__book_isbn => @form_data[:isbn]
        # }
        # @form_data = @form_data.merge(extra_book_info)

        # create the new book
        Book.create!(
          id: Book.maximum(:id).next,
          title: book_match.title,
          authors: book_match.authors,
          edition: "",
          publisher: book_match.publisher,
          isbn: @form_data[:isbn],
          image_id: file_name_on_s3
        )

        # search again for books with the given ISBN
        books_with_isbn = Book.where(isbn: @form_data[:isbn]).to_a
      end
    end

    # add the new book!
    if @form_data[:hidden_expandisbn] == "true"
      this_book = Book.create!(
        id: Book.maximum(:id).next,
        title: @form_data[:book_title],
        authors: @form_data[:book_authors],
        edition: @form_data[:book_edition],
        publisher: @form_data[:book_publisher],
        isbn: @form_data[:isbn],
        # no images when the book's info was manually inserted
      )
    else
      this_book = books_with_isbn[0]
    end

    # create the listing
    # TODO: How do we use course?
    @listing = Listing.find_by_id(@form_data[:hidden_draft_listing_id])
    @listing.book_id = this_book.id
    @listing.price = @form_data[:price]
    @listing.condition = @form_data[:condition]
    @listing.description = @form_data[:description]
    @listing.status = "published"
    @listing.save!

    @form_data = nil
    flash[:notice] = "Listing created!"
    redirect_to "/listing/#{@listing.id}"
  end

  def new
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    puts params
    puts @form_data

    if params[:isbn].nil? or params[:hidden_expandisbn].nil? or params[:hidden_draft_listing_id].nil?
      @form_data = {
        :isbn => "",
        :condition => "",
        :price => "",
        :course => "",
        :description => "",
        :hidden_expandisbn => false,
        :hidden_draft_listing_id => -1,
        :image => nil
      }
      flash[:notice] = nil
    else
      # store form info in a hash in case we need to return back to the form
      @form_data = {
        :isbn => params[:isbn].tr('^0-9', ''),  # sanitize
        :condition => params[:condition],
        :price => params[:price],
        :course => params[:course],
        :description => params[:description],
        :hidden_expandisbn => params[:hidden_expandisbn],
        :hidden_draft_listing_id => params[:hidden_draft_listing_id],

        :image => params[:image]
      }

      if @form_data[:hidden_expandisbn] == "true"
        extra_grabbed_info = {
          :book_title => params[:book_title],
          :book_authors => params[:book_authors],
          :book_edition => params[:book_edition],
          :book_publisher => params[:book_publisher],
          :hidden__book_isbn => params[:hidden__book_isbn]
        }
        @form_data = @form_data.merge(extra_grabbed_info)
      end

      if is_integer? params[:hidden_draft_listing_id]
        @form_data[:hidden_draft_listing_id] = params[:hidden_draft_listing_id].to_i
      else
        @form_data[:hidden_draft_listing_id] = -1
      end

      if @form_data[:hidden_draft_listing_id] >= 0
        @listing = Listing.find_by_id(@form_data[:hidden_draft_listing_id])
      end
    end

    render 'new', layout: 'other_pages'
    return
  end

  private
  def is_integer?(str)
    str.to_i.to_s == str
  end

  def bytes_to_megabytes (bytes)
    bytes / (1024.0 * 1024.0)
  end
end
