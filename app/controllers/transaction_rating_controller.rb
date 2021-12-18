class TransactionRatingController < ApplicationController
  layout 'other_pages'

  def form
    if session[:user_id].nil?
      redirect_to '/signin'
      return
    end

    listing_id = params[:id]
    @listing = Listing.find_by(id: listing_id)

    if @listing.nil?
      flash[:notice] = "Could not find the listing you are looking for."
      redirect_to controller: "search", action: 'index'
      return
    end

    # get the existing rating if one exists
    @existing_rating = UserReputationRating.find_by(listing_id: @listing.id)
    flash[:notice] = nil # clear flash notice
  end

  def submit
    if session[:user_id].nil?
      redirect_to '/signin'
      return
    end

    listing_id = params[:id]
    listing = Listing.find_by(id: listing_id)

    if listing.nil?
      flash[:notice] = "Could not find the listing you are looking for."
      redirect_to controller: "search", action: 'index'
      return
    end

    # extract submitted rating and verify that it was input as an integer (not a float or anything else)
    rating_submitted = params[:rating]
    unless is_integer? rating_submitted # proceed only if rating submitted is an integer and only an integer
      flash[:notice] = "Invalid rating."
      redirect_to "/listing/#{listing_id}/rate"
      return
    end

    # get existing rating
    existing_rating = UserReputationRating.find_by(listing_id: listing.id)

    # if existing rating does not exist, create a new one, else update the existing one
    if existing_rating.nil?
      UserReputationRating.create!(
        target_user_id: listing.seller.id,
        rater_user_id: listing.buyer.id,
        listing_id: listing.id,
        score: rating_submitted.to_i
      )
    else
      existing_rating.score = rating_submitted.to_i
      existing_rating.save!
    end

    # redirect back to the dashboard
    flash[:notice] = "Rating submitted!"
    redirect_to "/listing/#{listing.id}"
  end

  private
  def is_integer? inp
    inp.to_i.to_s == inp
  end

end
