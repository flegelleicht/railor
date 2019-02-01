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
