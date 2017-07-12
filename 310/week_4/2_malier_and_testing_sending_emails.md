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

~> production with send in blue example  
```ruby
#mailer config
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp-relay.sendinblue.com',
    port:                 587,
    domain:               'https://p-kuttiya-myflix.herokuapp.com/',
    user_name:            ENV['SEND_IN_BLUE_USERNAME'],
    password:             ENV['SEND_IN_BLUE_PASSWORD'],
    authentication:       :login,
    enable_starttls_auto: true
  }
```

~> [option1] switch email username and password to heroku vars  
~> `heroku config:set KEY_NAME=VALUE`  
~. `heroku config:set gmail_username=abc`  
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

# config development and production  
* config the host path for mailer if `_url` method helper in rails  
```ruby
#development.rb
config.action_mailer.default_url_options = { host: "localhost:3000" }

#production.rb
config.action_mailer.default_url_options = { host: "https://p-kuttiya-myflix.herokuapp.com/" }  
```

# Feature test for mailer  
* use capybara-email gem  
~> Easy test for ActionMailer  
~> Use in rspec features test  

* Useful methods  
~> `clear_emails`  
=> clear emails from ActionMailer::Base.deliveries  

~> open_email('test@example.com')  

~> current_email.click_link 'link name'  
=> set current_email after open email and click link in the email    