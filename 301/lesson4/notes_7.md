# Rails AJAX
* Rails have jquery.ujs for rails implementation ajax: _'SJR'_.

* Assigning `remote: true` in rails link/form to trigger rails ajax.  
~> Generate to HTML, with attached Javascript atrribute `'data-remote'=true`  
~> Build event listener and submit ajax request.  
~> Rails will process in controller as JS instead of HTML.

```erb
<!--_post.html.erb-->
<!--Send request to controller#vote-->
<%= link_to vote_post_path(post, vote: true), method: "post", remote: true do %>
  <!--...some html-->
<% end %>
<!--add id for handling js response-->
<span id="post_<%= post.id %>_votes">
  <%= post.total_votes %>
</span>
```

* Handle rails ajax request and create a response back in controller#action.  

```ruby
#posts_controller.rb
#revised code
def vote
  Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

  respond_to do |format|
    #Normal flow
    format.html { redirect_to :back, notice: "Voted" }

    #Ajax flow
    #format.js { render json: @post.to_json } #response will be json: @post
    
    #By default will render views/controller_name/#action.js.erb
    #Render views/posts/vote.js.erb
    format.js
  end
end
```

* Render the response with `vote.js.erb` file  
~> Will have access to instances in the _*CONTROLLER #VOTE ACTION*_  
~> Use erb syntax to access action#controller instances for .js.erb file.

```js
$('#post_<%= @post.id %>_votes').html('<%= @post.total_votes %>')
```

# SLUG
> By default `_path(arg`) method will call `to_param` method on argument
which returns the *id* as a slug  

* Create a slug column for DB Model in order to use as slug.    
~> change `to_param` instance method in prefered controller to modified slug.  
~> `rails g migration add_slug_to_posts`

```ruby
  class AddSlugToPosts < ActiveRecord :: Migration
    def change
      add_column :posts, :slug, :string
    end
  end
```

* Overwrite the `to_param` method in the preferred model  
~> Use ActiveRecord callback to execute method for generating slug  
before the model is saved or updated => `after_validation :generate_slug`    
~> Overwrite `to_param` instance method to get slug instead of id

```ruby
#models/post.rb
#additional code
after_validation :generate_slug

def generate_slug
  self.slug = self.title.gsub(/\W+/, '-').downcase
end

def to_param
  self.slug
end
```

* Run rails console and update slug  

> !!! WARNING DO NOT RUN THIS COMMAND IN PRODUCTION  
!!! Use migration instead.

```ruby
# will call generate_slug method before save
Post.all.each {|post| post.save}
```

* Update controller to find instance in action by slug.

```ruby
#posts_controller
#revised code
  @post = Post.find_by(slug: params[:id])
```

# Admin permission
* Add string column 'role' to User DB.

* Add methods to check for roles in User model

```ruby
#models/user.rb
def admin?
  self.role == 'admin'
end
```

* Add method to validate admin in ApplicationController  
~> add method to view_helper to be able to validate admin in view.

```ruby
#application_controller
#additional code
def access_denied
  flash[:error] = "Not admin"
  redirect_to root_path
end

def require_admin
  access_denied unless current_user.admin?
end
```

# Time Zone
* set default time zone in `application.rb`

```ruby
#application.rb
#revised code
config.time_zone = '...'
```

> run `rake -T | grep time` to see rake command for time  
run `rake time:zones:all | grep US` to get all us time zones.

* Add time zone selection for login users  
~> `rake g migration add_time_zone_to_users`  
~> add_column string to User DB

* Use ActiveSupport method helper for selection of time zones  

```erb
<!--additional code for _form.html.erb-->
  <div class="control-group">
    <%= f.label :time_zone %>
    <%= f.time_zone_select :time_zone, ActiveSupport::TimeZone.us_zones %>
  </div>
```

* whitelisted time_zone in users_controller `user_params`  
 to save timezone when save to DB

```ruby
#users_controller.rb
#modified code
def user_params
  params.require(:user).permit(:username, :password, :time_zone)
end
```

* modify time_zone method in view helper
```ruby
#application_controller
#modified code
def display_datetime(dt)
  #if logged_in and timezone not blank
  if logged_in? && !current_user.time_zone.blank?
    dt = dt.in_time_zone(current_user.time_zone)
  end

  dt.strftime("%m/%d/%Y %l:%M%P %Z")
end
```