## Python

### Download a file

from urllib import urlretrieve
urlretrieve('http://railor:3000/uploads/erik-hebisch-foto.1024x1024.jpg', 'erik.jpg')

## Ruby

## Upload a file with only the std lib

require "net/http"
uri = URI("http://thumbor:8888/image")
http = Net::HTTP.new(uri.host, uri.port)
req = Net::HTTP::Post.new(uri.path)
req.body = IO.read("public/uploads/FILE.jpg")
req.content_type = "image/jpeg"
res = http.request(req)

