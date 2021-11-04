class ListingController < ApplicationController
  def show
    listing_id = params[:id]
    begin
      @listing = Listing.find(listing_id)
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
    end
  end
end
