# Ruby on Rails on Docker
Ruby Version 2.6.2

# Heroku URL
https://ultra-task-manager.herokuapp.com/
# How to Deploy to Heroku 
```bash
$ docker-compose run --rm web rails webpacker:clobber webpacker:compile
$ heroku container:rm web
$ heroku container:push web
$ heroku container:release web
$ heroku run rails webpacker:clobber webpacker:compile   
$ heroku run rails db:migrate # table加えたときのみ
$ heroku open 
```
# How to DB reset
```bash
$ heroku pg:reset DATABASE_URL
$ heroku run rails db:migrate db:seed 
```
