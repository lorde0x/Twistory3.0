class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery #with: :exception
	before_action :take_current_host
	
	def take_current_host
		# @current_host = "http://" + request.host
		if Rails.env.production?
			@current_host = "http://www.ragazzidel99.it"
		else
			@current_host = "http://localhost:3000"
		end
	end

end
