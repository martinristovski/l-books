class SessionsController < ApplicationController
    layout 'home'
    def new
        @fdata = {
          :redirect_url => request.referrer
        }
        puts @fdata
    end

    def create
        # finds existing user, checks to see if user can be authenticated
        user = User.find_by(email: params[:email])
        puts params[:redirect_url]

        if user.nil?
            flash[:notice] = 'Invalid email or password'
            render :new
            return
        end

        if user.present? && user.authenticate(params[:password])
            session[:user_id] = user.id
            if params[:redirect_url].nil?
                redirect_to root_path, notice: 'Logged in successfully'
            else
                redirect_to params[:redirect_url], notice: 'Logged in successfully'
            end
        else
            flash[:notice] = 'Invalid email or password'
            render :new
        end
    end

    def destroy
        if session[:user_id].nil?
            redirect_to root_path, notice: 'Cannot log out if you never logged in.'
            return
        end

        session[:user_id] = nil
        if request.referrer.nil?
            redirect_to root_path, notice: 'Logged Out'
        else
            redirect_to request.referrer, notice: 'Logged Out'
        end
    end
end