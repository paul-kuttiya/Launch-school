## Sidekiq
* Background jobs processing for rails  

* Process jobs asynchronously  
~> `install gem sidekiq in gemfile`  

* Will use Redis; in memory processing db to maintain jobs queue for background jobs processing   
~> Install Redis locally for development and testing   

* Not good to store obj in Sidekiq, store only id  
~> job processor;redis can be on different server on production  

* Use Sidekiq library, ActiveRecord, ActionMalier or  
~> create `/app/workers/name_worker.rb`  
```ruby
  class SomethingWorker
    include Sidekiq::Worker

    def perform(obj_id)
      #some_code
    end
  end
```

~> inside file that need background perform then call perform_asyn on Worker class   
```ruby
#some_controller.rb
def create
  SomethingWorker.perform_asyn(@obj.id)
end
```

* run `bundle exec sidekiq`  

* monitoring workers  
~> modify routes in config file  
```ruby
mount Sidekiq::Web, at: '/sidekiq'  
```
~> install `gem 'sinatra', require: false`  
~> install `gem 'slim'`  
~> `bundle`  
~> check sidekiq API to add access protection on production  

## Some useful sidekiq API  
* ActionMailer  
```ruby
AppMailer.delay.welcome_email(user.id)  
AppMailer.delay_for(5.days).welcome_email(user.id)
AppMailer.delay_until(5.days.from_now).welcome_email(user.id)
```

* ActionMailer Test  
~> Test workers inline to make tests run syn instead of asyn  
~> add `require 'sidekiq/testing/inline'` to `spec_helper.rb`  