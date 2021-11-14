class SessionsController < ApplicationController
    def new; end

    def create
        # finds existing user, checks to see if user can be authenticated
        user = User.find_by(email: params[:email])

        if user.present? && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to root_path, notice: 'Logged in successfully'
        else
            flash[:notice] = 'Invalid email or password'
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: 'Logged Out'
    end
end