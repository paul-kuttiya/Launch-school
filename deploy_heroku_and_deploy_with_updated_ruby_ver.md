# heroku deploy steps

* install heroku CLI  
ubuntu:  
`wget -qO- https://cli-assets.heroku.com/install-ubuntu.sh | sh`

* git files need to be root repo
* go into folder
* heroku login
* heroku create app-name

> then modify on heroku web --> setting for app for package build to node.js

* git add -A
* git push heroku master

## For rails
* heroku restart
* heroku run rake db:migrate
* heroku run rake db:seed

> or `heroku run rake db:reset`

> reset database: `heroku pg:reset DATABASE --confirm`  

### if error  
> fatal: 'heroku' does not appear to be a git repository  
 fatal: Could not read from remote repository.  
~> `heroku login`  
~> `heroku git:remote -a yourapp`  
~> `add and push heroku master`  

# Update ruby version and deploy
## Myflix

* specified local ruby version by heroku ruby supported version    
~> `ruby '2.2.7'` lowest ver at 07/2017
~> `rbenv local 2.2.7`

* delete Gemfile.lock  

* update gem version to fix terminal log errors for gems     
~> `gem 'rails', '4.1.9'`  
~> `gem 'pg', '0.20'`  
~> `bundle`  

* `ruby 2.2.7` DOES NOT SUPPORT `.size` method  
~> switch to `.length`  

* run rake command  
~> `rake db:migrate`  
~> `rake db:reset`  