class RegistrationsController < ApplicationController
    layout 'home'

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = 'Successfully created account'
            redirect_to root_path
        else
            flash[:notice] = @user.errors.full_messages
            render :new
        end
    end

    private
    def user_params
        # strong parameters
        params.require(:user).permit(:email, :first_name, :last_name, :uni, :school, :password, :password_confirmation)
    end
end