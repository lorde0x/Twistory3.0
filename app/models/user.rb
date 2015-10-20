class User < ActiveRecord::Base
	has_many :feeds
	mount_uploader :image, ImageUploader
	after_create :send_new_registration_email
	
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable, :confirmable,
		:recoverable, :rememberable, :trackable, :validatable

	validates :name, presence: true
		
	def send_new_registration_email
		UserMailer.new_registration_email(self).deliver_later
	end
end
