class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery #with: :exception
	before_action :set_local
	rescue_from I18n::InvalidLocale, with: :default_locale

	def default_url_options(options = {})
  		{ locale: I18n.locale }.merge options
	end

	private

	def default_locale
		I18n.locale = :en
		redirect_to home_index_path
	end

	def set_local
		I18n.locale = params[:locale] || env.http_accept_language.preferred_language_from(I18n.available_locales)
	end
end
