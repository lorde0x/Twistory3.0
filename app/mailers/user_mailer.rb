class UserMailer < ApplicationMailer

	def new_registration_email(user)
		@user = user
		
		if Rails.env.production?
			mail(:to => 'info@ragazzidel99.it', :subject => "Un nuovo utente si e' iscritto.")
		else
			mail(:to => 'lorenzo22@hotmail.it', :subject => "Un nuovo utente si e' iscritto.")
		end
	end

	def trigger_error_email(error_message)
		@error_message = error_message.to_s
			if Rails.env.production?
				mail(:to => 'info@ragazzidel99.it', :subject => @error_message)
			else
				mail(:to => 'twittwar95@gmail.com', :subject => @error_message)
			end
	end
	
end
