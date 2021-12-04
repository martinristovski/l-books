class SessionsController < ApplicationController
    layout 'other_pages'
    def new; end

    def create
        # finds existing user, checks to see if user can be authenticated
        user = User.find_by(email: params[:email])

        if user.nil?
            flash[:warning] = 'Invalid email or password'
            render :new
            return
        end

        if user.present? && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to root_path, notice: 'Logged in successfully'
        else
            flash[:warning] = 'Invalid email or password'
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: 'Logged Out'
    end
end