require 'twitter'

namespace :send_feeds_to_socials do
	
	desc "Send Feeds to LaGrandeGuerra Twitter channel and Facebook Italian page"
	task send_feeds_italian: :environment do
		
		time_now = DateTime.now		
		box = Feed.where("is_ita_published = ? and date < ?", '0', time_now)
		ctrl = box.length		

		if ctrl > 0 && !box.publishing == false
			client = Twitter::REST::Client.new do |config|
				if Rails.env.production?
					config.consumer_key = APP_CONFIG['twitter']['production_italian']['consumer_key']
					config.consumer_secret = APP_CONFIG['twitter']['production_italian']['consumer_secret']
					config.access_token = APP_CONFIG['twitter']['production_italian']['access_token']
					config.access_token_secret = APP_CONFIG['twitter']['production_italian']['access_token_secret']
				else
					config.consumer_key = APP_CONFIG['twitter']['development']['consumer_key']
					config.consumer_secret = APP_CONFIG['twitter']['development']['consumer_secret']
					config.access_token = APP_CONFIG['twitter']['development']['access_token']
					config.access_token_secret = APP_CONFIG['twitter']['development']['access_token_secret']
				end
			end
		
			i = 0
		
			while i != ctrl do
			
				feed_text = box[i].text_ita
			
				# Dead code
				# feed_text.gsub(/'/){ "`" }
				# feed_text.gsub(/"/){ "`" }
			
				# Appending the #LaGrandeGuerra hashtag
				feed_text = feed_text + " #LaGrandeGuerra"
			
				twitter_response = nil
			
				# Case 1: no pictures are posted
				if !box[i].image.present?
					if feed_text.length <= 140
						twitter_response = client.update(feed_text)
					
						# Verify that twitter_response is not blank
						if !twitter_response.blank? and !twitter_response.id.blank?
							box[i].update_attribute(:is_ita_published, true)
						
							# If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
							# TODO: we should also trigger an error email to info@ragazzidel99.it
						
							###################################################################################
							# Sending the same feed to the Facebook channel.
							# Initially we relied on Twitter to forward the feed to Facebook. However, we discovered this 
							# approach is unreliable so we are now posting directly to Facebook.
							#facebook_consumer_key = APP_CONFIG['facebook']['production']['access_token']
							if Rails.env.production?
								facebook_app_secret = APP_CONFIG['facebook']['production_italian']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['production_italian']['page_token']
							else
								facebook_app_secret = APP_CONFIG['facebook']['development']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['development']['page_token']
							end
						
							#graph = Koala::Facebook::API.new(facebook_consumer_key, facebook_app_secret)
							page_graph = Koala::Facebook::API.new(facebook_page_token, facebook_app_secret)
						
							page_graph.put_connections("me", "feed", :message => feed_text)
							#
							###################################################################################
						
						else
							box[i].update_attribute(:is_ita_published, false)
						end
					else
						UserMailer.trigger_error_email("Pubblicazione sui social non riuscita in data: " + Time.now.strftime('%d-%m-%Y %H:%M:%S').to_s).deliver_now
					end
				# Case 2: pictures are posted
				else
					# When sending pictures, Twitter creates a http URL that may count towards up to 23 characters
					# As a result, only 140 - 23 = 117 characters are left
					if feed_text.length <= 117
						twitter_response = client.update_with_media(feed_text, File.new(box[i].image.path))
					
						# Verify that twitter_response is not blank
						if !twitter_response.blank? and !twitter_response.id.blank?
							box[i].update_attribute(:is_ita_published, true)
						
							# If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
							# TODO: we should also trigger an error email to info@ragazzidel99.it
						
							###################################################################################
							# Sending the same feed to the Facebook channel.
							# Initially we relied on Twitter to forward the feed to Facebook. However, we discovered this 
							# approach is unreliable so we are now posting directly to Facebook.
							#facebook_consumer_key = APP_CONFIG['facebook']['production_english']['access_token']
							if Rails.env.production?
								facebook_app_secret = APP_CONFIG['facebook']['production_italian']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['production_italian']['page_token']
							else
								facebook_app_secret = APP_CONFIG['facebook']['development']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['development']['page_token']
							end
						
							#graph = Koala::Facebook::API.new(facebook_consumer_key, facebook_app_secret)
							page_graph = Koala::Facebook::API.new(facebook_page_token, facebook_app_secret)
						
							page_graph.put_picture(box[i].image.path, {:message => feed_text}, "me")
							#
							###################################################################################
						
						else
							box[i].update_attribute(:is_ita_published, false)
						end
					else
						UserMailer.trigger_error_email("Pubblicazione sui social non riuscita in data: " + Time.now.strftime('%d-%m-%Y %H:%M:%S').to_s).deliver_now
					end
				end
			
				# TODO: Use rescue for exception handling in case and error occurs.
				# For instance, when accidentally sending feeds to Twitter with length greater than 140,
				# the twitter gem produces a fatal error and exits the task immediately with Twitter::Error::Forbidden: Status is over 140 characters.
			
				## use the line below to debug:
				## puts "\n\nctrl: #{ctrl}, i: #{i}\ntime now: #{time_now}\nhas_been: #{box[i].has_been_published}\nfeed text: #{box[i].feed_text}"
			
				i = i+1
			
			end # end while loop #
		end # end initial if statement # 
	end	# end send_feeds_italian task 
	
	desc "Send Feeds to WW1fromItaly Twitter Channel and Facebook English page"
	task send_feeds_english: :environment do
		
		time_now = DateTime.now
		box = Feed.where("is_eng_published = ? and date < ?", 'false', time_now)
		ctrl = box.length
		
		if ctrl > 0 && !box.publishing == false
			client = Twitter::REST::Client.new do |config|
				if Rails.env.production?
					config.consumer_key = APP_CONFIG['twitter']['production_english']['consumer_key']
					config.consumer_secret = APP_CONFIG['twitter']['production_english']['consumer_secret']
					config.access_token = APP_CONFIG['twitter']['production_english']['access_token']
					config.access_token_secret = APP_CONFIG['twitter']['production_english']['access_token_secret']
				else
					config.consumer_key = APP_CONFIG['twitter']['development']['consumer_key']
					config.consumer_secret = APP_CONFIG['twitter']['development']['consumer_secret']
					config.access_token = APP_CONFIG['twitter']['development']['access_token']
					config.access_token_secret = APP_CONFIG['twitter']['development']['access_token_secret']
				end
			end
		
			i = 0
		
			while i != ctrl do
			
				feed_text = box[i].text_eng
			
				if feed_text.blank?
					next
				end
			
				# Appending the #WW1fromItaly hashtag
				feed_text = feed_text + " #WW1fromItaly"
			
				twitter_response = nil
			
				# Case 1: no pictures are posted
				if !box[i].image.present?
					if feed_text.length <= 140
						twitter_response = client.update(feed_text)
					
						# Verify that twitter_response is not blank
						if !twitter_response.blank? and !twitter_response.id.blank?
							box[i].update_attribute(:is_eng_published, true)
						
							# If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
							# TODO: we should also trigger an error email to info@ragazzidel99.it
						
							###################################################################################
							# Sending the same feed to the Facebook channel.
							# Initially we relied on Twitter to forward the feed to Facebook. However, we discovered this 
							# approach is unreliable so we are now posting directly to Facebook.
							#facebook_consumer_key = APP_CONFIG['facebook']['production']['access_token']
							if Rails.env.production?
								facebook_app_secret = APP_CONFIG['facebook']['production_english']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['production_english']['page_token']
							else
								facebook_app_secret = APP_CONFIG['facebook']['development']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['development']['page_token']
							end
						
							#graph = Koala::Facebook::API.new(facebook_consumer_key, facebook_app_secret)
							page_graph = Koala::Facebook::API.new(facebook_page_token, facebook_app_secret)
						
							page_graph.put_connections("me", "feed", :message => feed_text)
							#
							###################################################################################
						else
							box[i].update_attribute(:is_eng_published, false)
						end
					else
						UserMailer.trigger_error_email("Pubblicazione sui social non riuscita in data: " + Time.now.strftime('%d-%m-%Y %H:%M:%S').to_s).deliver_now
					end
				# Case 2: pictures are posted
				else
					# When sending pictures, Twitter creates a http URL that may count towards up to 23 characters
					# As a result, only 140 - 23 = 117 characters are left
					if feed_text.length <= 117
						twitter_response = client.update_with_media(feed_text, File.new(box[i].image.path))
					
						# Verify that twitter_response is not blank
						if !twitter_response.blank? and !twitter_response.id.blank?
							box[i].update_attribute(:is_eng_published, true)
						
							# If, by any chance, the twitter_response has issues, set the "has_been_published" attribute to a third undefined state
							# TODO: we should also trigger an error email to info@ragazzidel99.it
						
							###################################################################################
							# Sending the same feed to the Facebook channel.
							# Initially we relied on Twitter to forward the feed to Facebook. However, we discovered this 
							# approach is unreliable so we are now posting directly to Facebook.
							#facebook_consumer_key = APP_CONFIG['facebook']['production_english']['access_token']
							if Rails.env.production?
								facebook_app_secret = APP_CONFIG['facebook']['production_english']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['production_english']['page_token']
							else
								facebook_app_secret = APP_CONFIG['facebook']['development']['app_secret']
								facebook_page_token = APP_CONFIG['facebook']['development']['page_token']
							end
						
							#graph = Koala::Facebook::API.new(facebook_consumer_key, facebook_app_secret)
							page_graph = Koala::Facebook::API.new(facebook_page_token, facebook_app_secret)
						
							page_graph.put_picture(box[i].feed_image.path, {:message => feed_text}, "me")
							#
							###################################################################################
						else
							box[i].update_attribute(:is_eng_published, false)
						end
					else
						UserMailer.trigger_error_email("Pubblicazione sui social non riuscita in data: " + Time.now.strftime('%d-%m-%Y %H:%M:%S').to_s).deliver_now
					end
				end
			
				# TODO: Use rescue for exception handling in case and error occurs.
				# For instance, when accidentally sending feeds to Twitter with length greater than 140,
				# the twitter gem produces a fatal error and exits the task immediately with Twitter::Error::Forbidden: Status is over 140 characters.
			
				i = i+1
			
			end # end while loop #
		end # end initial if statement #
	end # end send_feeds_english task #
end # end namespace #


