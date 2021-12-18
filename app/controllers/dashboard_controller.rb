class DashboardController < ApplicationController
  layout 'other_pages'

  def show
    if session[:user_id].nil?
      redirect_to '/signin'
      return
    end

    # find the user in question
    @user = User.find_by(id: session[:user_id])

    # if @user.nil?
    #   flash[:notice] = "Sorry, we couldn't find the user you're logged in as."
    #   redirect_to controller: "search", action: 'index'
    #   return
    # end
  end
end
