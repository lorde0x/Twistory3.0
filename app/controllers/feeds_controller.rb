require 'google/api_client'
require 'json'

class FeedsController < ApplicationController
	before_action :set_feed, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:home, :confirmation_page]
	around_filter :user_time_zone, :if => :current_user

	def home
		@feeds = Feed.all
	end

	def confirmation_page	
	end

	def index
		@feeds = Feed.all
	end


	def show
	end

	def new
		@feed = Feed.new
	end

	def edit
	end

	def create
		@feed = Feed.new(feed_params)
		@feed.user_id = current_user.id
			# Translate from the original Italian text to English via Google Translate APIs in production mode
		if Rails.env.production?
			feed_text_english = translate_feed(@feed.text_ita)
				if !(feed_text_english.blank?)
					if @feed.image.blank?
						if feed_text_english.size > 126
							feed_text_english = feed_text_english.slice(0, 123) + '...'
							flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
						end
					elsif feed_text_english.size > 101
						feed_text_english = feed_text_english.slice(0, 98) + '...'
						flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
					else
						flash[:notice] = 'Entrambi i feeds sono stati aggiornati con successo'
					end
				end
				@feed.text_eng = feed_text_english.gsub("\xE2\x80\x8B", "")
		else
			@feed.text_eng = 'Hi there! Write here the english traslation'
		end
			respond_to do |format|			
				if @feed.save
					format.html { render :edit, notice: 'Il feed è stato creato!' }
					format.json { render :show, status: :created, location: @feed }
				else
				format.html { render :new }
				format.json { render json: @feed.errors, status: :unprocessable_entity }
				end
			end
	end

	def update
		respond_to do |format|
			if @feed.user_id == current_user.id && @feed.update(feed_params)
					if @feed.text_eng.blank?
						flash[:notice] = 'Il feed Italiano è stato aggiornato con successo'
					else
						if @feed.image.blank?
							if @feed.text_eng.size > 124
								@feed.text_eng = @feed.feed_text_english.slice(0, 121) + '...'
								flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
							end
						elsif @feed.text_eng.size > 101
							@feed.feed_text_english = @feed.feed_text_english.slice(0, 98) + '...'
							flash[:notice] = 'Il feed inglese è stato abbreviato perchè superava il limite di caratteri'
						else
							flash[:notice] = 'Entrambi i feeds sono stati aggiornati con successo'
						end
					end
				format.html { redirect_to feeds_path }
				format.json { render :show, status: :ok, location: @feed }
			else
				format.html { redirect_to feeds_url }
				format.json { render json: @feed.errors, status: :unprocessable_entity }
				flash[:notice] = 'Non puoi modificare questo feed'
			end
		end
	end

	def destroy
		respond_to do |format|
			if (@feed.user_id == current_user.id) && @feed.destroy				
				format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
				format.json { head :no_content }
			else
				format.html { redirect_to feeds_url }
				format.json { render json: @feed.errors, status: :unprocessable_entity }
				flash[:notice] = 'Non puoi distruggere questo feed'
			end
		end
	end

	private

# Use Google Translate APIs to translate feed text from the original Italian to English
	def translate_feed(text_ita)
		google_client = Google::APIClient.new(
			:application_name => APP_CONFIG['google']['production']['application_name'],
			:key => APP_CONFIG['google']['production']['key'],
			:application_version => '1.0.0',
			:authorization => nil
		)
		
		# Load client secrets from your client_secrets.json
		# NOT needed for the Google Translate APIs
		# client_secrets = Google::APIClient::ClientSecrets.load
		
		translate = google_client.discovered_api('translate', 'v2')
		
		result = google_client.execute(
			:api_method => translate.translations.list,
			:parameters => {
				'format' => 'text',
				'source' => 'it',
				'target' => 'en',
				'q' => text_ita
			}
		)
		
		parsed = JSON.parse(result.data.to_json)
		
		# Example of data returned
		# {"translations":[{"translatedText":"This is a pen"}]}'
		
		english_translation = parsed["translations"][0]["translatedText"]
		
		# TODO: return a warning if the translation is over 140 characters (or whatever limit we have)

		return english_translation
	end
	# translate_feed end #
	def set_feed
		@feed = Feed.find(params[:id])
	end

	def feed_params
		params.require(:feed).permit(:user_id, :text_ita, :text_eng, :image, :date, :publishing)
	end

	def user_time_zone(&block)
		if params[:locale] == "en"
			Time.use_zone("GMT", &block)
		else
			Time.use_zone("CET", &block)
		end
	end
end
