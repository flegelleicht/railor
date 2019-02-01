1. Create app

	```
	$ docker run -it -v "$PWD":/app:cached flgl/rails:5.2.2 new railor
	$ cd railor
	```

2. Scaffold `Post`

	```
	$ docker-compose exec railor rails generate scaffold Post title:string content:text
	$ docker-compose exec railor rails db:migrate
	```

3. Create alias for rails command

	```
	$ alias rails='docker-compose exec railor rails'
	```

4. Create controller for uploads

		```
		$ rails generate controller upload
		```

5. Create model for remembering uploaded pictures in db

		```
		$ rails generate model Image name:string path:string
		```

6. Push uploaded images to thumbor

	```
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
	```

7. Save thumbor location in model

	```
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
```	

8. Show images via thumbor

	```
	def index
		@view = OpenStruct.new({
			images: Image.all.map{|i| 
				OpenStruct.new(
					url: "http://localhost:8888/unsafe/400x400/http://localhost:8888#{i.path}")}
		})
	end
	```

## Conclusions

* Thumbor can handle image uploads, but:
	* uploaded images still have to addressed via an url, resulting in strange
		looking urls with duplicate hostnames like "http://localhost:8888/unsafe/600x400/http://localhost:8888#{i.location}"
	* uploaded images are not stored in the file storage and are thus not found
		via the file loader
	* uploaded images are lost on container restart
* Images should be stored in a fault-tolerant system, maybe S3
* Thumbor is then used for its processing power
* Maybe thumbor should even be hidden behind a proxy/cdn to have nicer urls
	* `https://images.ausbildung.de/<hmac>/300x200/<url http://cdn.ausbildung.de/images/...>`
	* maybe as described here:
	  [https://en.99designs.de/tech-blog/blog/2013/07/01/thumbnailing-with-thumbor/](https://en.99designs.de/tech-blog/blog/2013/07/01/thumbnailing-with-thumbor/)

## References

* thumbor
	* [https://github.com/thumbor/thumbor/wiki/Usage](https://github.com/thumbor/thumbor/wiki/Usage)
	* [https://www.dadoune.com/blog/best-thumbnailing-solution-set-up-thumbor-on-aws/](https://www.dadoune.com/blog/best-thumbnailing-solution-set-up-thumbor-on-aws/)
	* [https://github.com/thumbor/ruby-thumbor](https://github.com/thumbor/ruby-thumbor)
	* [https://blog.wikimedia.org/2017/12/09/thumbor-journey-development-deployment-strategy/](https://blog.wikimedia.org/2017/12/09/thumbor-journey-development-deployment-strategy/)
* Down- and uploading files from the commandline
	* [https://stackoverflow.com/questions/12667797/using-curl-to-upload-post-data-with-files](https://stackoverflow.com/questions/12667797/using-curl-to-upload-post-data-with-files)
	* [https://stackoverflow.com/questions/9134003/binary-data-posting-with-curl](https://stackoverflow.com/questions/9134003/binary-data-posting-with-curl)
	* [https://stackoverflow.com/questions/17162995/downloading-a-file-from-the-command-line-using-python](https://stackoverflow.com/questions/17162995/downloading-a-file-from-the-command-line-using-python)
* Rails
	* [https://stackoverflow.com/questions/1992019/how-can-i-rename-a-database-column-in-a-ruby-on-rails-migration](https://stackoverflow.com/questions/1992019/how-can-i-rename-a-database-column-in-a-ruby-on-rails-migration)

