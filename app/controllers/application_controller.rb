class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception     
  
  include SessionsHelper  
  
  ##### Perfecto solo que no logea bien la login screen, por so lo comento. ver con fincic.
  before_action :signed_in_user, except: [ :home ]    
end
