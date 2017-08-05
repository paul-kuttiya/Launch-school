* Puma and sidekiq
~> Puma is webworker, spawn threads for requests  
~> sidekiq is background processor, use extra spawned threads from puma and run assign job in background.  
~> will make requests faster since will assign heavy lifting job to background.  

* install add-on 'Redis To Go' on heroku  
~> Redis server for heroku  
~> Will use Redis; in memory processing db to maintain jobs queue for background jobs processing   

* set heroku to use ridis to go, or include in circle.yml file later on  
~> `heroku config:set REDIS_PROVIDER=REDISTOGO_URL`

## Unicorn  
* HTTP server for Rack application  
~> install `gem unicorn`  
~> follow heroku documents to include Procfile  
`web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb`  
~> follow heroku documents and include `config/unicorn.rb`  
```ruby
# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
```
~> [optional] refer Free background jobs on heroku for free web workers on heroku  

## Puma [Recommended]  
* another web worker option  

* recommend instead of unicorn  

* install puma gem  
```ruby
group :development, :staging, :production do
  gem 'puma'
end
```

* config in `Procfile`  
```ruby
#dev env
web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
#production env
web: bundle exec puma -C config/puma.rb
#with sidekiq background processing running at production
worker: bundle exec sidekiq -e production -c 3
```

* add `/config/puma.rb`  
```ruby
workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
```