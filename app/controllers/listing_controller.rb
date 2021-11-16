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
        :isbn => params[:isbn],
        :condition => params[:condition],
        :price => params[:price],
        :course => params[:course],
        :description => params[:description],
        :hidden_expandisbn => params[:hidden_expandisbn]
      }

      # some simple checks
      if @form_data[:isbn].nil? or @form_data[:isbn].empty?
        flash[:notice] = "Please enter an ISBN."
        render 'new', layout: 'other_pages'
        return
      end

      if @form_data[:condition].nil? or @form_data[:condition].empty?
        flash[:notice] = "Please enter the book's condition."
        render 'new', layout: 'other_pages'
        return
      end

      if @form_data[:price].nil? or @form_data[:price].empty?
        flash[:notice] = "Please enter the book's price."
        render 'new', layout: 'other_pages'
        return
      end

      if @form_data[:description].nil? or @form_data[:description].empty?
        flash[:notice] = "Please enter a description for the book."
        render 'new', layout: 'other_pages'
        return
      end

      # add extra fields if the form had them
      if @form_data[:hidden_expandisbn]
        extra_grabbed_info = {
          :book_title => params[:book_title],
          :book_authors => params[:book_authors],
          :book_edition => params[:book_edition],
          :book_publisher => params[:book_publisher],
          :hidden__book_isbn => params[:hidden__book_isbn]
        }
        @form_data = @form_data.merge(extra_grabbed_info)

        if @form_data[:book_title].nil? or @form_data[:book_title].empty?
          flash[:notice] = "Please enter the unknown book's title."
          # TODO: Could render a different template here for the longer form.
          render 'new', layout: 'other_pages'
          return
        end

        if @form_data[:book_authors].nil? or @form_data[:book_authors].empty?
          flash[:notice] = "Please enter the unknown book's author list."
          # TODO: Could render a different template here for the longer form.
          render 'new', layout: 'other_pages'
          return
        end

        if @form_data[:book_publisher].nil? or @form_data[:book_publisher].empty?
          flash[:notice] = "Please enter the unknown book's publisher."
          # TODO: Could render a different template here for the longer form.
          render 'new', layout: 'other_pages'
          return
        end
      end

      # search for this ISBN
      sanitized_isbn = @form_data[:isbn].tr('^0-9', '') # strip all non numeric chars
      books_with_isbn = Book.where("isbn like ? OR isbn = ?", "%#{sanitized_isbn}%", "%#{sanitized_isbn}%")

      # if book with isbn not found, return the lengthened form
      if books_with_isbn.size == 0 and @form_data[:hidden_expandisbn] == false
        @form_data[:hidden_expandisbn] = true
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
      end

      # add the new book!
      if @form_data[:hidden_expandisbn] == true
        this_book = Book.create!(
          title: @form_data[:book_title],
          authors: @form_data[:book_authors],
          edition: @form_data[:book_edition],
          publisher: @form_data[:book_publisher],
          isbn: @form_data[:hidden__book_isbn],
          # image_url: "https://images-na.ssl-images-amazon.com/images/I/61xbfNmcFwL.jpg" # TODO: Images later.
        )
      else
        this_book = books_with_isbn[0]
      end

      # create the listing
      # TODO: How do we use course?
      created_listing = Listing.create!(
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
