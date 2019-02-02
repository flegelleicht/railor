class UploadController < ApplicationController
	def show
	end

	def index
		@view = OpenStruct.new({
			images: Image.all.map{|i| 
				OpenStruct.new(
					#url: "http://localhost:8888/unsafe/600x400/filters:blur(20):max_bytes(10000)/http://localhost:8888#{i.location}"
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
#		require "net/http"
#		uri = URI("http://thumbor:8888/image")
#		http = Net::HTTP.new(uri.host, uri.port)
#		req = Net::HTTP::Post.new(uri.path)
#		req.body = IO.read(file.tempfile)
#		req.content_type = "image/jpeg"
#		res = http.request(req)
#		res.each_header.to_h["location"]
	end
end

