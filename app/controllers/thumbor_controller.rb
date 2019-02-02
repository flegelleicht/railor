class ThumborController < ApplicationController
	def load
		image = Image.find(params[:location])
		data = RestClient.get("http://thumbor:8888/unsafe/600x400/http://thumbor:8888#{image.location}")
		send_data data.body
	end
end
