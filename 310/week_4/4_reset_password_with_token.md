# Reset password with token

## forget_password controller
* create forgot_password link and page  
~> add `link_to "Forget Password", forgot_password_path` at sign in page   
~> route get path  `get '/forgot_password', to: 'forgot_passwords#show'`  
~> route post path `resources :forgot_passwords, only: [:create]`   
~> implement controller for forgot_passwords
~> implement page for forgot_password  
```haml
<!--add non-model backed form-->
= form_tag forgot_passwords_path, class: "sign_in" do
<!--form inputs-->
```

* TDD for forget_password controller create action   
~>  
context "with blank input"  
it "redirects to the forgot password page"  
it "shows error message"  

~>  
context "with existing email"  
it "redirects to forgot password confirmation page"  
it "sends email to email address"  
it "generates user token"  

~>  
context "with non-existing email"  
it "redirects to the forgot password page"  
it "shows error message"

* Implement logic and view in TDD  
~> forgot_password_confirmation get/post routes and view  
~> route to get forgot_passwords#confirm action, show that email is sent page   
~> create template for forgot_password#confirm    
~> implement send_forgot_password method to mailer controller  
```ruby
#app_mailer.rb
def send_forgot_password(user)
  mail to: user.email,
  from: "info@myflix.com",
  subject: "Please reset the password"
end
```
~> create view template for mailer send_forgot_password action  
~> include user link in email template to reset password with token   

#### Create token column for user  
* add column for users table, and set default to nil  
~> `rails g migration add_column :users, :token, :string, default: nil`  

* add generate token method to user model  
```ruby
def generate_token
  self.token = loop do
    random_token = SecureRandom.urlsafe_base64(nil, false)
    break random_token unless User.exists?(token: random_token)
  end
end
``` 

* run migration

## reset password controller
* user needs to reset password from `/password_reset/#{some_random_token}`  
~> use token as url params[:id]  

* in the email send to user  
~> use `_url` instead of `_path`, since it would be linked from user email outside of web ui  
~> need `link_to "Reset password", password_reset_url(@user.token)  
~> no need to overwrite `to_param` to look for token, since passing @user.token as a path in `_url`     
~> set host in development for `_url`  
```ruby
#config/development.rb
config.action_mailer.default_url_options = { host: 'localhost:3000' }
```

* create routes for reset password show page  
~> create get for password_resets, `resources :password_resets, only: [:show]`  

* create controller for password_resets  

* TDD "GET show"  
~> it "renders show template if the token is valid"  
~> it "sets @token"  
~> it "redirects to expired token page if the token is invalid"  

* TDD "GET show implementation   
~> add template for show path  
~> add expired token page and path  
~> `get '/expired_token', to: 'password_resets#expired_token'`  
~> sets @token from user in show action  
~> add non model-backed form, need hidden field token to identify user when posted to server    
~> use user token as hidden token
```haml
= form_tag password_resets_path do
<!--other form inputs-->
  = hidden_field_tag :token, @token
```

* TDD "POST create"  
~>  
context "with valid token"  
  it "redirects to sign in page"  
  it "updates user password"  
  it "sets flash success message"  
  it "deletes token"  
~>  
context "with invalid token"  
  it "redirects to expired token path"  

* TDD "POST create" implementation  
~> find user and reset password if valid token  
~> save new user password to DB  
~> delete token  
~> flash and redirects to signin page  
~> redirects to expire page if invalid token  

## Deploy
* set smtp and default url in `config/production.rb`  
```ruby
#config/production.rb
config.action_mailer.default_url_options = { host: 'yourweb_url' }
```

* Consider adding timestamps for token reset to expired password for more security