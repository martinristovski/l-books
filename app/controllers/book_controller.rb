class BookController < ApplicationController
  layout 'other_pages'

  def show
    book_id = params[:id]
    begin
      @book = Book.find(book_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a book with that ID."
      redirect_to controller: "search", action: 'index'
    end
  end
end
