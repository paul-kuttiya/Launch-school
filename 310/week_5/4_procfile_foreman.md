## Procfile
* on production, eg: heroku  
~> define process type and command in procfile for production  
~> will execute webserver and workers when deploy on production  
```ruby
#procfile
web: bundle exec rails server -p $PORT
work: sidekiq
```

~> `heroku ps` to find the current running processes; dynos  
~> `heroku logs` will print worker and server logs  

* on local  
~> `foreman start`  
~> will run procfile  