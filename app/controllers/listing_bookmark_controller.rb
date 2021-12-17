class ListingBookmarkController < ActionController::Base
  def create
    listing_id = params[:id]
    @listing = Listing.find_by_id(listing_id)

    if @listing.nil? or @listing.status == "draft"
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
      return
    end

    if session[:user_id].nil?
      redirect_to '/signin' # TODO: Redirect back.
      return
    end

    # check for an existing bookmark
    user_id = session[:user_id]
    existing_bookmark = ListingBookmark.find_by(listing_id: listing_id, user_id: user_id)

    if existing_bookmark.nil?
      # this listing has not been bookmarked by this user, so create it
      ListingBookmark.create!(listing_id: listing_id, user_id: user_id)
      flash[:notice] = 'Listing bookmarked!'
    else
      # this listing HAS been bookmarked by this user, so delete it
      existing_bookmark.destroy
      flash[:notice] = 'Bookmark removed!'
    end

    redirect_to "/listing/#{listing_id}"
  end
end
