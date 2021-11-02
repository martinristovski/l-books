class BookController < ApplicationController
  def show
    book_id = params[:id]
    begin
      p book_id
      if book_id.nil?
        redirect_to controller: "search", action: 'index'
      else
        @book = Book.find(book_id)
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a book with that ID."
      redirect_to controller: "search", action: 'index'
    end
  end
end
