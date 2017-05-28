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
~> password validations used for password_confirmation  
~> need password and password_confirmation for validations  
~> for manual password validation, set validations to **false** to turn off password_confirmation

```ruby
class User < ActiveRecord::Base
#... some code
  has_secure_password validations: false
end
```

* need to work with bcrypt **'bcrypt-ruby'** & **'bcrypt'**
~> add gem to Gemfile
~> without postgresql `bundle install --without production`
~> `bundle update`
```ruby
gem 'bcrypt-ruby', '~> 3.0.1'
gem 'bcrypt', '~> 3.1.7'
```

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

* validates username in User model  
~> validates :username, presence: true, uniqueness: true  

* validates password in User Model, **ONLY FOR create action**  
~> errors only for create action  
~> validates :password, presence: true, on: :create, length: {minimum: 3}

* Create user routes
~> specified custom routes, and create users route 
```ruby
#routes
#... some code

#rails auto create 'register_path' method
get '/login', to: 'sessions#new' #login form
post '/login', to: 'sessions#create'
get '/logout', to: 'session#destroy'

get '/register', to: 'users#new'
resources :users, only: [:create]
```
* create action in users_controller and form in views
```ruby
#users_controller
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Registered"
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages
      redirect_to register_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
```

```erb
<!--form-->
<div class="well">
  <%= form_for @user do |f| %>
    <div class="control-group">
      <%= f.label :username %>
      <%= f.text_field :username %>
    </div>
    <div class="control-group">
      <%= f.label :password %>
      <%= f.password_field :password %>
    </div>
    <%= f.submit "Register", class: 'btn btn-success' %>
  <% end %>
</div>  
```

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

### pass extra params key into _route_path_ method

* eg: use for tabs  

* pass extra key: value into _route_path_ method  
~> `user_path(@user, tab: 'comments')`  
~> access value by `params[:key]`   
~> the link will generate `url?key=value`

* eg: display **li="active"** base on `params[:tab]` conditions

```erb
<ul class="nav nav-tabs">
  <li class=<%= "active" if params[:tab].nil? %>>
    <%= link_to "Posts (#{@user.posts.size})", user_path(@user) %>
  </li>
  <li class=<%= "active" if params[:tab] == "comments" %>>
    <%= link_to "Comments (#{@user.comments.size})", user_path(@user, tab: 'comments') %>
  </li>
</ul>
```

* show tab elements based on params[:tab] condotion
```erb
<% if params[:tab].nil? %>
  <% @user.posts.each do |post| %>
    <%= render '/posts/post', post: post %>
  <% end %>
<% elsif params[:tab] == "comments" %>
  <% @user.comments.each do |comment| %>
    <%= render '/comments/comment', comment: comment, show_post: true %>
  <% end %>
<% end %>
```

* create show_post condition, and set link to user and post source.  
~> link_to() user and post base on user/post  
~> set `show_post ||= false` in comment template  
~> when render template pass in `show_post: true` if want to show.

```erb
<% show_post ||= false %>

<div class="row">
  <div class="span4 well">
    <% if show_post %>
      <p>on <em><%= link_to comment.post.title, post_path(comment.post) %></em></p>
    <% end %>
    <em><%= comment.body %></em>
    <p>
      <span class="quiet">posted by <%= link_to(comment.creator.username, user_path(comment.creator)) %></span>
      <small>at <%= comment.created_at %></small>
    </p>
  </div>
</div>
```

* disallowed editing other users  
~> add before_action method to check if current_user  
which stord in the session is the same as user at params[:id]  

```ruby
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update]

#other code...
  def edit; end

  def update
    #some code
  end

  private
  #other code...

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    unless @user = current_user
      flash[:error] = "not permit"
      redirect_to user_path(current_user)
    end
  end
end
```