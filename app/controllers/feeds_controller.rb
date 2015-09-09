class FeedsController < ApplicationController
	before_action :set_feed, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:home]

	def home
		@feeds = Feed.all
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
			respond_to do |format|
				if current_user.permissions == 100
					@feed.update_attributes(:publishing => false)
				end
				
				@feed.user_id = current_user.id
				
				if @feed.save
					format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
					format.json { render :show, status: :created, location: @feed }
					flash[:notice] = "Il feed è stato creato"
				else
				format.html { render :new }
				format.json { render json: @feed.errors, status: :unprocessable_entity }
				end
			end
	end

	def update
		respond_to do |format|
			if @feed.user_id == current_user.id 
				@feed.update(feed_params)
				format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
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
			if @feed.user_id == current_user.id
				@feed.destroy
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

	def set_feed
		@feed = Feed.find(params[:id])
	end

	def feed_params
		params.require(:feed).permit(:user_id, :text_ita, :text_eng, :image, :date, :publishing)
	end
end
