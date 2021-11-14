class PasswordResetsController < ApplicationController
  def new; end

  def edit
    # finds user with a valid token
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    flash[:notice] = 'Your token has expired. Please try again.'
    redirect_to signin_path
  end

  def update
    # updates user's password
    @user = User.find_signed!(params[:token], purpose: 'password_reset')
    if @user.update(password_params)
      flash[:notice] = 'Your password was reset successfully. Please sign in'
      redirect_to signin_path
    else
      render :edit
    end
  end

  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end