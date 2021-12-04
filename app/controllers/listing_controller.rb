class ListingController < ApplicationController
  layout 'other_pages'

  def show
    listing_id = params[:id]
    begin
      @listing = Listing.find(listing_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
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
        :description => listing_in_question.description
      }

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

  def new
    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    if request.get?
      @form_data = {
        :isbn => "",
        :condition => "",
        :price => "",
        :course => "",
        :description => "",
        :hidden_expandisbn => false
      }
      flash[:notice] = nil
      render 'new', layout: 'other_pages'
    elsif request.post?
      # store form info in a hash in case we need to return back to the form
      @form_data = {
        :isbn => params[:isbn].tr('^0-9', ''),  # sanitize
        :condition => params[:condition],
        :price => params[:price],
        :course => params[:course],
        :description => params[:description],
        :hidden_expandisbn => params[:hidden_expandisbn]
      }

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

      # if book with isbn not found, return the lengthened form or populate using Google Books API
      if books_with_isbn.empty? and @form_data[:hidden_expandisbn] == "false"
        @form_data[:hidden_expandisbn] = true
	
	books_match = GoogleBooks.search(@form_data[:isbn], {:api_key => ENV["API_KEY"]}) #returns collection of books that match the isbn

        book_match = books_match.first

	if book_match.nil?
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
	  extra_book_info = {
            :book_title => book_match.title,
            :book_authors => book_match.authors,
            :book_edition => "", # todo: make this optional?
            :book_publisher => book_match.publisher,
            # todo: add image to s3, using book_match.image_link(:zoom => 2) for a medium sized image
            :hidden__book_isbn => @form_data[:isbn]
          }
          @form_data = @form_data.merge(extra_book_info)
          render 'new', layout: 'other_pages'
          return
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
          isbn: @form_data[:isbn]
          # image_url: "https://images-na.ssl-images-amazon.com/images/I/61xbfNmcFwL.jpg" # TODO: Images later.
        )
      else
        this_book = books_with_isbn[0]
      end

      # create the listing
      # TODO: How do we use course?
      created_listing = Listing.create!(
        id: Listing.maximum(:id).next,
        book_id: this_book.id,
        price: @form_data[:price],
        condition: @form_data[:condition],
        description: @form_data[:description],
        seller_id: session[:user_id]
      )

      @form_data = nil
      flash[:notice] = "Listing created!"
      redirect_to "/listing/#{created_listing.id}"
    end
  end
end
