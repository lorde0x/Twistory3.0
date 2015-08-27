class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery #with: :exception
	before_action :take_current_host
	before_action :set_locale
	
	def take_current_host
		# @current_host = "http://" + request.host
		if Rails.env.production?
			@current_host = "http://www.ragazzidel99.it"
		else
			@current_host = "http://localhost:3000"
		end
	end
	
	def set_locale
		logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
		I18n.locale = extract_locale_from_accept_language_header
		logger.debug "* Locale set to '#{I18n.locale}'"
	end
	
	private
		def extract_locale_from_accept_language_header
			request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
		end

end
