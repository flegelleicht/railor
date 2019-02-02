class UploadController < ApplicationController
	def show
	end

	def index
		@view = OpenStruct.new({
			images: Image.all.map{|i| 
				OpenStruct.new(
					url: "/thumbor/#{i.id}"
				)}
		})
	end

	def upload
		picture = upload_params[:picture]
		location = upload_to_thumbor(picture)
		Image.create do |image|
			image.name = picture.original_filename
			image.location	= location
		end
		redirect_to uploads_path
	end

	private

	def upload_params
		params.permit(:picture)
	end

	def upload_to_thumbor(file)
		res = RestClient::Request.execute(
			method: :post,
			url: 'http://thumbor:8888/image',
			headers: { 
				'Content-Type': 'image/jpeg'
			},
			payload: file.tempfile
		)
		res.headers[:location]
	end
end

