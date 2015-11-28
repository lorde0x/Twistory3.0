class RegistrationsController < Devise::RegistrationsController

	private

	# Modified Devise params for user login
	def sign_up_params
		params.require(:user).permit(:email, :password, :password_confirmation, :name)
	end

	def after_inactive_sign_up_path_for(resource)
		'/confirmation_page' # Or :prefix_to_your_route
	end
end