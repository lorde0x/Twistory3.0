class Feed < ActiveRecord::Base
	belongs_to :user
  	mount_uploader :image, ImageUploader

	validate :checking_feed_text
	validate :checking_for_date
	validate :checking_for_image_size

	private

	def checking_for_image_size
		if image.size > 300.kilobytes
			errors[:base] = "L\'immagine non può superare 300 Kb"
		end
	end

	def checking_feed_text
		if !(text_ita.present? and text_eng.present?)
			errors[:base] = "Non puoi pubblicare feed vuoti!"
		elsif image.present? and text_ita.size > 101 and text_eng > 101
			errors[:base] = "I feeds con immagini non possono contenere più di 101 caratteri!"
		elsif text_ita.size > 124 || text_eng.size > 124
			errors[:base] = "I feeds non possono contenere più di 124 caratteri!"
		end
	end

	def checking_for_date
		if !(date.present?)
			errors[:base] = "E\' necessario inserire una data di pubblicazione per il feed!"
		elsif date.utc <= DateTime.now.utc
			errors[:base] = "La data di pubblicazione non può essere nel passato!"
		end
	end
end
