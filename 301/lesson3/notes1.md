# ActiveModel::SecurePassword
* authentication, one way hashing with bcrypt.

* need password_digest column/attribute

* define has_secure_password in Model

## create user authentication
* create migration which add password_digest column  
  ~> run `rails generate migration add_users_password_digest`

```ruby
#migration file
class AddUsersPasswordDigest < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
  end
end
```

* migrate to DB ~> `rake db:migrate`

* define **has_secure_password** in the Model  
~> password validations used for password confirmation  
~> need password and password_confirmation for validations  
~> for manual password validation, set validations to **false** to turn off password_confirmation

```ruby
class User < ActiveRecord::Base
#... some code
  has_secure_password validations: false
end
```

* need to work with bcrypt **'bcrypt-ruby'**  
~> add `gem 'bcrypt-ruby', '~> 3.0.0'`  to gem file  
~> without postgresql **bundle install --without production**

* `has_secure_password` method gives ONLY **setter** virtual attributes without getter  
~> setter: `u.password = 'password'`   
~> setter will set one way hash bcrypt user password to password_digest

* password_digest cannot be retrive directly from DB  
~> compare password with password_digest by passing string in instance authenticate method.  
~> `u.authenticate('password')`  
~> returns authenticated object if password matched  
~> false if password not matched.

## Create user registration and login
### - USER
* Create user routes
~> specified custom routes, and create users route 
```ruby
#routes
#... some code

#rails auto create 'register_path' method
get '/register', to: 'users#new'
get '/login', to: 'sessions#new' #login form
post '/login', to: 'sessions#create'
get '/logout', to: 'session#destroy'

resources :users, only: [:create]
```
* create action in users_controller and form in views

* validates username in User model  
~> validates :username, presence: true, uniqueness: true  

* validates password in User Model, **ONLY FOR create action**  
~> validates :password, presence: true, on: :create, length: {minimum: 3}

### - SESSION
* For user login

* Create _**NON MODEL-BACKED FORM**_ for sessions form  

```erb
  <%= form_tag '/login' do %>
    <div class="control-group">
      <%= label_tag :username %>
      <%= text_field_tag :username, params[:username] || '' %>
    </div>
    <div class="control-group">
      <%= label_tag :password %>
      <%= password_field_tag :password, params[:password] || '' %>
    </div>
    <%= submit_tag "Log in", class: 'btn btn-success' %>
  <% end %>
```

* Create sessions_controller  
~> set user_id to session when logged in successfully in create action
~> `session[:user_id] = user.id`

> Rails session persists between requests. The session is only available in the controller and the view

```ruby
  class SessionsController < ApplicationController
    def new
    end

    def create
      #no session model/validates settings
      #will not returns errors for instance hence no instance needed.
      user = User.find_by(username: params[:username])

      #if user is true bypass 
      #user.authenticate(params[:password]) will return obj if password matched.
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:notice] = "You've logged in."
        redirect_to posts_path
      else
        flash[:error] = "Wrong username or password."
        # render "new"
        redirect_to login_path
      end
    end

    def destroy
      session[:user_id] = nil
      flash[:notice] = "You've logged out"
      redirect_to root_path
    end
  end
```

* in `ApplicationColtroller ` create methods to detect sessions  
~> define `helper_method` to expose method to helper_method in View

```ruby
class ApplicationColtroller
#exposed ApplicationColtroller methods to helper_method View
  helper_method :current_user, :logged_in?

  def current_user
    #memorization
    #set current user to itself if existed or ... if not existed
    #need 'if' since .find() will raise RecordNotFound if cannot be found
    @current_user ||= User.find(session[:user_id]) if session([:user_id])
  end

  def logged_in?
    !!current_user
  end
end
```

* modify view base on sessions, eg: navbar, edit, profile  
~> use `ApplicationController` methods to check session

```erb
<!--nav bar-->
<% if logged_in? %>
  <li>Hi <%= current_user.username %></li>
<% else %>
  <li><%= link_to "Register", register_path %></li>
  <li><%= link_to "Login", login_path %></li>
<% end %>
```

* Create control-access action based on authentication.  
~> Redirect manual navigation url if not authenticated.  
~> Create method `require_user` in `ApplicationController`

```ruby
#ApplicationController
#... some code
def require_user
  unless logged_in?
    flash[:error] = "Must log in."
    redirect_to posts_path
  end 
end
```

* Modify controller permission using `require_user` method from `ApplicationController`  
~> eg: posts, comments, categories controller

```ruby
#posts_controller
#...addtional code
before_action :require_user, except: [:index, :show]
```

* set user to model relation  
~> set `@comment.creator` to `current_user` method  
~> set `@post.creator` to `current_user` method  

```ruby
#comments_controller
#...addtional code
#The same as @comment.user_id = current_user.id
#But better use vitual attribute setter
def create
  #...
  @comment.creator = current_user
end

#posts_controller
def create
  #...
  @post.creator = current_user
end
```