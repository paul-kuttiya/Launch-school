# Send email in rails  
* Extend `ActionMailer::Base` class  
~> all methods's context are class method  
~> Define method  
```ruby
#app/mailers/app_mailer.rb
class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, 
    from: "info@myflix.com",
    subject: "Welcome to Myflix!"
  end
end
```

* Create body of the email in views templates  
~> views template will act to files  
inside `app/mailers` as controller  
and method inside as action 
~> `app/views/app_mailer/send_welcome_email`   
```haml
%html
  %body
    %p Welcome to MyFlix, #{@user.full_name}!
```

* implement into a preferred method  
~> call deliver on method  
```ruby
  #users_controller.rb
  def create
    #other code
    if @user.save
      AppMailer.send_welcome_email(@user).deliver
    end
  end
```

* Install `gem 'letter_opener'` in gemfile  
~> `bundle`  
~> will display email sending in browser for dev ENV instead of server log   
```ruby
  gem :development do
    gem 'letter_opener'
  end
```
~> config in `config/development.rb`  
```ruby
#other code
config.action_mailer.delivery_method = :letter_opener
```

* modify `config/production.rb` smtp settings  
~> use heroku to store information instead of hard coding  
```ruby
#using gmail examples
#not ideal to use gmail for real production
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'gmail.com',
    user_name:            'xyz@gmail.com',
    password:             'yourpassword',
    authentication:       :login,
    enable_starttls_auto: true
  }
```

~> [option1] switch email username and password to heroku vars  
```ruby
#other codes
:username => ENV['gmail_username'],
:password => ENV['gmail_password']
```

~> [option2] use figaro gem

## TDD for mailer
* implement test context in `user#create` action  
~> use `deliveries` method to check for email queue  
~> use `deleveries.last.to` to get array of last sent email array  
~> use `deleveries.last.body` to get ActionMailer body obj then test with `include`  

* codition tests   
~> 'it sends out email to user with valid inputs'  
~> 'it sends out email to valid input user with user full name'  
~> 'it does not send email with invalid inputs'  

* `ActionMailer::Base` works different from DB in spec  
~> mail deliveries queue will not roll back as testing DB  
~> is not a Transaction  
~> in spec need to add after block to clear mailing queue  
```ruby
  after { ActionMailer::Base.deleiveries.clear }
```