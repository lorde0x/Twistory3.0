class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery #with: :exception
	include HttpAcceptLanguage::AutoLocale
	
	private
	
	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( :email, :password, :password_confirmation, :name) }
	end
end
