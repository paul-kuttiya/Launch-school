# Form

* Rails comes with it owns csurf hidden input which prevent from forgery.  

* Best way to create form in rails is **'model-backed forms helpers'**  

* when submitted, form will generate   
params = {..., "instance" => {"model_attr => "value" }, ..}  

* the parameter passed in each method needs to be co-response
  with the @instance's Model attributes, virtual attributes or column name for mass assignment when form is submitted; create action.

```erb
<!--@instance needs to be defined in controller#new action-->
<%= form_for @instance do |f| %>
  <!--the parameter passed in each method needs to be co-response
  with the Model attributes, virtual attributes, column name-->
  <%= f.label :title %>
  <%= f.text_field :title %>
  <br>
  <%= f.submit "Create", class: "some-class" %>
<% end %>
```

## Strong parameter 
* move mass-assignment protection out of the model and into the controller where it belongs.  

* an interface for protecting attributes from mass assignment unless whitelisted.

### Form create

```ruby
#Controller
class PostsController < ApplicationController
#...some code
  #GET
  def new
    @post = Post.new
  end

  #POST
  def create
    #will mass assign
    @post = Post.new(post_params)

    if @post.save #returns true
      #assign notice key = string in flash obj
      flash[:notice] = "Post was created"
      redirect_to posts_path
    else
      #if failed, return false, will render the new template
      render :new
    end
  end

#DRY by defining strong parameter in private method
  private
  def post_params
    #require post obj key
    #returns post's value, {title: "", url: "", creator: ""}
    params.require(:post).permit(:title, :url, :creator)

    #whitelisted all
    <!--params.require(:post).permit!-->
  end
end
```

## Validate input

* Validate in Model layer for displaying error messages.

```ruby
#Model
class Post < ActiveRecord::Base
  #...some code

  # if validate fail, will returns false
  # then error messages array can be access through
  # @instance.errrors.full_messages
  validate :title, presence: true
end
```

```erb
<!--in form template-->
<% if @post.errors.any? %>
  <% @post.errors.full_messages.each do |msg| %>
    <li><%= msg %></li>
  <% end %>
<% end %>
```

* if error, class "field_with_errors" will be added to error input ~> add style to specify error input.

### Form edit & update 
* IF the obj is existing obj passed in form_for, rails form helper will get attributes, display attributes and map to update action "/controller/id".

* Rails find the update action by creating hidden input which has '_method' attribute pointed to HTTP verb.

```ruby
#Controller
class PostsController < ApplicationController
#...some code
  #execute method before specified action
  before_action :set_post, only: [:show, :edit, :update]

  def show
  end

  #GET
  def edit
  end

  #PATCH
  def update
    if @post.update(post_params)
      flash[:notice] = "The post is updtaed"
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  private
  def post_params
    params.require(:post).permit!
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
```

* nested routes form ~> show comment form in "/posts/:id/comments"

```ruby
#Post Controller
class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  #...some code

  #GET FORM for comment in post#show action
  def show
    # @post is existing
    # @comment need to be new to generate the new form in template
    @comment = Comment.new
  end

  private
  #...some code

  def set_post
    @post = Post.find(params[:id])
  end
end
```

```ruby
#Comments controller
class CommentsController < ApplicationController
  #POST comment form
  def create
    @comment = Comment.new(params.require(:comment).permit!)

    #in nested form, parent id will have name prepended
    #check with binding pry or form input
    @post = Post.find(params[:post_id])

    if @comment.save
      flash[:notice] = "Add comment"
      redirect_to post_path(@post)
    else
      <!--render template file-->
      render "posts/show"
    end
end
```

```erb
<!--form template for route /posts/:id/comments-->
<!--from show action
@post is existing obj, @comment is new obj-->
<%= form_for [@post, @comment] do |f| %>
  <%= f.text_area :body %>
  <br>
  <%= f.submit "Create", class: "some class" %>
<% end %>
```