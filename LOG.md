1. Create app

    $ docker run -it -v "$PWD":/app:cached flgl/rails:5.2.2 new railor
    $ cd railor

2. Scaffold `Post`

    $ docker-compose exec railor rails generate scaffold Post title:string content:text
    $ docker-compose exec railor rails db:migrate

3. Create alias for rails command

    $ alias rails='docker-compose exec railor rails'

4. Create controller for uploads

    $ rails generate controller upload

5. Create model for remembering uploaded pictures in db

    $ rails generate model Image name:string path:string

6. Push uploaded images to thumbor

  	def upload_to_thumbor(file)
  		require "net/http"
  		uri = URI("http://thumbor:8888/image")
  		http = Net::HTTP.new(uri.host, uri.port)
  		req = Net::HTTP::Post.new(uri.path)
  		req.body = IO.read(file.tempfile)
  		req.content_type = "image/jpeg"
  		res = http.request(req)
  		res.each_header.to_h["location"]
  	end

7. Save thumbor location in model

		Image.create do |image|
			image.name = picture.original_filename
			image.path = location
		end
   
  	def upload
  		picture = upload_params[:picture]
  		location = upload_to_thumbor(picture)
  		Image.create do |image|
  			image.name = picture.original_filename
  			image.path = location
  		end
  		redirect_to uploads_path
  	end
    
8. Show images via thumbor

  	def index
  		@view = OpenStruct.new({
  			images: Image.all.map{|i| 
  				OpenStruct.new(
  					url: "http://localhost:8888/unsafe/400x400/http://localhost:8888#{i.path}")}
  		})
  	end

