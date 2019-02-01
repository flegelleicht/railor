class UploadController < ApplicationController
	def show
	end

	def upload
		picture = upload_params[:picture]
		File.open(Rails.root.join('public', 'uploads', picture.original_filename), 'wb') do |file|
			file.write(picture.read)
		end
	end

	def upload_params
		params.permit(:picture)
	end
end
