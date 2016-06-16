class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	include CanCan::ControllerAdditions
	include SessionsHelper 
	include ApplicationHelper 
	protect_from_forgery with: :exception     

	##### Perfecto solo que no logea bien la login screen, por so lo comento. ver con fincic.
	before_action :signed_in_user, except: [ :home ]   

	def current_ability
		@current_ability ||= Ability.new(current_user)
	end
end
