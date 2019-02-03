class ThumborController < ApplicationController
	def load
		image = Image.find(params[:location])
		url = Thumbor::Cascade.new(
			ENV['THUMBOR_SECURITY_KEY'], 
			"http://thumbor:8888#{image.location}"
		).width(600).height(400).generate
		data = RestClient.get("http://thumbor:8888#{url}")
		send_data data.body
	end
end
