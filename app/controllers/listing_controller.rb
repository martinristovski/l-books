class ListingController < ApplicationController
  def show
    listing_id = params[:id]
    begin
      p listing_id
      if listing_id.nil?
        redirect_to controller: "search", action: 'index'
      else
        @listing = Listing.find(listing_id)
      end
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, we couldn't find a listing with that ID."
      redirect_to controller: "search", action: 'index'
    end
  end
end
