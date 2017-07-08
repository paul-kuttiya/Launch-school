# Send email in rails  
* Extend `ActionMailer::Base` class  
~> all methods's context are class method  
~> Define method  
```ruby
#app/mailers/app_mailer.rb
class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = uesr
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
~> will display email sending in browser for dev ENV  
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