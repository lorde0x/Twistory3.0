class FeedsController < ApplicationController
	before_action :set_feed, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!

	# GET /feeds
	# GET /feeds.json
	def index
		@feeds = Feed.all
	end

	# GET /feeds/1
	# GET /feeds/1.json
	def show
	end

	# GET /feeds/new
	def new
		@feed = Feed.new
	end

	# GET /feeds/1/edit
	def edit
	end

	# POST /feeds
	# POST /feeds.json
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

	# PATCH/PUT /feeds/1
	# PATCH/PUT /feeds/1.json
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

	# DELETE /feeds/1
	# DELETE /feeds/1.json
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
	# Use callbacks to share common setup or constraints between actions.
	def set_feed
		@feed = Feed.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def feed_params
		params.require(:feed).permit(:user_id, :text_ita, :text_eng, :image, :date, :publishing)
	end
end
