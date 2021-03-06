class SessionsController < ApplicationController
  before_action :signed_in_user, except: [ :create ]  

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to the user's show page.
      sign_in user
      redirect_to home_path
    else
      flash[:alert] = 'email/password combinacion invalida' # Not quite right!      
      redirect_to home_path 
    end
  end

  def destroy
  	  sign_out
      redirect_to root_url
  end
end
