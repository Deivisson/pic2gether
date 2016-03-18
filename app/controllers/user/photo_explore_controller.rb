class User::PhotoExploreController < User::BaseController
	def index
		@photos	= Photo.all.order("created_at desc")
		@photos = @photos.where(category_id:params["category_id"]) if params["category_id"].present?
		if params[:search]
			@photos = @photos.where("(title ~* :str) or (description ~* :str) or (tags ~* :str)", str: "#{params[:search]}")
		end
		@gallary_type 	= params[:gallary_type] || "flow" 
		@categories			= Category.all
		render layout: "user/explorer"
	end

	def show
    @photo_comment = PhotoComment.new
		@photo = Photo.find(params[:photo_id])
		@photo.update_views!(current_user,request.remote_ip)
	end

end