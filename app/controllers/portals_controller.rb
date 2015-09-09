class PortalsController < ApplicationController
	before_action :authenticate_admin!
	before_action :set_portal, only: [:show, :edit, :update, :destroy]

	def index
		@portals = Feed.all
	end

	def show
	end

	def new
		@portal = Feed.new
	end

	def edit
	end

	def create
		# @portal = Feed.new(feed_params)
			# respond_to do |format|	
				# @portal.user_id = 100000000
				# if @portal.save
					# format.html { redirect_to @portal, notice: 'Feed was successfully created.' }
					# format.json { render :show, status: :created, location: @portal }
					# flash[:notice] = "Il feed è stato creato"
				# else
				# format.html { render :new }
				# format.json { render json: @portal.errors, status: :unprocessable_entity }
				# end
			# end
	end

	def update
		respond_to do |format| 
			if @portal.update(feed_params)
				format.html { redirect_to portals_path, notice: 'Feed was successfully updated.' }
				format.json { render :show, status: :ok, location: @portal }
			else
				format.html { redirect_to feeds_url }
				format.json { render json: @portal.errors, status: :unprocessable_entity }
				flash[:notice] = 'Non puoi modificare questo feed'
			end
		end
	end
	
	def destroy
		respond_to do |format|
			if @portal.destroy
				format.html { redirect_to portals_path, notice: 'Feed was successfully destroyed.' }
				format.json { head :no_content }
			else	
				format.html { redirect_to feeds_url }
				format.json { render json: @portal.errors, status: :unprocessable_entity }
				flash[:notice] = 'Non puoi distruggere questo feed'
			end
		end
	end

	private

	def set_portal
		@portal = Feed.find(params[:id])
	end

	def feed_params
		params.require(:portal).permit(:user_id, :text_ita, :text_eng, :image, :date, :publishing)
	end
end
