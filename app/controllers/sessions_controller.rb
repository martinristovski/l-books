class SessionsController < ApplicationController
    layout 'other_pages'
    def new
        if @fdata.nil? # unless the redirect url was preserved in a previous request, assign @fdata anew
            @fdata = {
              :redirect_url => request.referrer
            }
        end
        puts @fdata
    end

    def create
        # finds existing user, checks to see if user can be authenticated
        user = User.find_by(email: params[:email])

        if user.nil?
            flash[:warning] = 'Invalid email or password'
            @fdata = {  # re-form fdata to preserve the redirect url
              :redirect_url => params[:redirect_url]
            }
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
            flash[:warning] = 'Invalid email or password'
            @fdata = {  # re-form fdata to preserve the redirect url
              :redirect_url => params[:redirect_url]
            }
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