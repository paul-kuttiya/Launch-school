# Active record migration & model
## migration
* Ruby DSL that change/define/create schema table without interecting directly with SQL known as ORM, Object Relational Mapper
* Each migration modifies DB: add/remove/change tables or columns.
* eg create users table command ~> **'rails generate migration create_users'**.
* Table file name is plural, model name is singular eg. table categories, model category

```ruby
#in migration file ...create_users.rb
  class CreateUsers < ActiveRecord::Migration
    def change
      create_table :users do |t|
        #specify table attributes/columns
        t.string :username
        t.timestamps
      end
    end
  end
```

* runs **'rake db:migrate'**, rake is ruby DSL for make.
* db:migrate will run the changes for all migrate that have not yet been run.

## model
* Model is where all the core logic related to data, relationships btw models, validation, scopes.
* create file in /models ~> file name is singular snake case from migration **file ~> user.rb**

```ruby
#class user subclass from ActiveRecord::Base
  class User < ActiveRecord::Base
  end
```

> Or rails generate model User username: string --skip-migration --skip-test

## Set up one to many association
* add foreign key 1:M by adding fk to many side table, eg. posts
* create new migration for DB ~> **'rails generate migration add_user_id_to_posts'**

```ruby
#in migration file ...add_user_id_to_posts.rb
  class AddUserIdToPosts < ActiveRecord::Migration
    def change
      #adding column to existing table using add_column method
      #add_column(table_name, column_name, type, options = {})
      #full method add_column(:posts, :user_id, :integer)
      add_column :posts, :user_id, :integer
    end
  end
```

* update DB by run **'rake db:migrate'**
* update association in model to look for fkey and link tables.

```ruby
#One side
#in models/user.rb file
  class User < ActiveRecord::Base
    has_many :posts
  end

#Many side
#in models/post.rb file
  class Post < ActiveRecord::Base
    #Rails will assume that fkey is 'user_id' and 'class User'
    belongs_to :user
  end
```
> When setup association, will also have virtual attributes within the model, ie: getter and setter.  
**has_many :posts ~> getter and setter for posts (collection array)**.  
**belongs_to :user ~> getter and setter for user (object)**.

> virtual attributes ~> attributes that are given by association and not in the columns DB, can be use in mass assignment  
eg. Post.create(title: "some title", creator: User.first)  

> Diagram: **[1:M diagram](./1-M_association.png)**

## Set up Many to many, M:M association
* Need join table for 2 tables, with own id and fk from each table.
* Each table can have many value from the other table.
* Create each table using migration.
* Create join table using migration, then reference fk to each table model.

```ruby
#...
def change
  create_table :post_categories do |t|
    t.integer :category_id, :post_id
  end
end
```

> Table name in rails can be find out by ~> **"ModelName".tableize"**  in rails console ~> eg. PostCategory.tableize == "post_categories"

* Run migration
* Create model for each table as well as joined table.

```ruby
#JOINED TABLE
#models/post_category.rb
class PostCategory < ActiveRecord::Base
  #has that table fk == belongs_to that table, singular 
  belongs_to :post
  belongs_to :category
end
```

```ruby
#TABLE 1
#models/post.rb
class PostCategory < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  #has fk in that table == has_many that table, plural
  #- M:M association within model.
  #- has many from joined table.
  #- has many of the other table through joined table.
  has_many :post_categories
  has_many :categories, thorugh: :post_categories
end
```

```ruby
#TABLE 2
#models/category.rb
class Category < ActiveRecord::Base
  has_many :post_categories
  has_many :posts, through: :post_categories
end
```
> Verified the model by creating data via association in rails console.

# Route and Controller
> view all routes and path by running ~> **'rake routes'**
> naming controller ~> tableName_controller.rb ~> posts_controller.rb

* Route defines what to do with the request by sending to controller.

```ruby
#routes.rb
AppTemplate::Application.routes.draw do
  #define root route to posts controller at index method
  root to: 'posts#index'

  get '/posts', to: 'posts#index'
end
```

```ruby
#posts_controller.rb
class PostsController < ApplicationController
  #By default the action will render the view template
  def index
    # render 'index'
    # render :index
    # render 'posts/index'
  end
end
```

* Define params in route and pass in controller via instance variable to find data in the model and render dynamically.

```ruby
#routes.rb
AppTemplate::Application.routes.draw do
  #...some code

  # params = {
  #  "controller"=>"posts", 
  #  "action"=>"show", 
  #  "id"=>"params in browser url"
  # }
  get '/posts/:id', to: 'posts#show'
end
```

```ruby
#posts_controller.rb
class PostsController < ApplicationController
  #...some code

  def show
    # params can be reference in controller through routes
    # define instance variable to be able to access it in view.
    @post = Post.find(params[:id])
  end
end
```

```erb
<!--show.html.erb-->
<h4><%= @post.title %></h4>
```

* Controller method represent view with the same name, hence instances create within controller can pass into that view.

```ruby
def show
  # @post can be accessed in views/posts/show.erb.html 
  @post = Post.all
end
```

* Class model can be passed directly into view

```erb
<% Post.all.each do |p| %>
  <li><%= p %></li>
<% end %>
```

#### Routes **'resources'**

* resources will generate routes and **'..._path'** method for all routes

```ruby
#routes.rb
AppTemplate::Application.routes.draw do
  #...some code

  # get '/posts', to: 'posts#index'
  # get '/posts/:id', to: 'posts#show'
  # get '/posts/new', to: 'posts#new'
  # post '/posts', to: 'posts#create'
  # get '/posts/:id/edit', to: 'posts#edit'
  # patch '/posts/:id', to: 'posts#update'

  #equivalent to 
  resources :posts, except: [:destroy]
end
```

* Meaningful routes, nested routes

```ruby
#routes.rb
AppTemplate::Application.routes.draw do
  #...some code

  resources :posts, except: [:destroy] do
    resources :comments, only: [:create]
  end
end
```

## View
* Build the link in view

```erb
<!--show.html.erb-->
<h4><%= @post.title %></h4>

<!--routes method url helper-->
<%= link_to 'back to all posts', posts_path %>

<!--link_to is a method taking string, path as parameters-->
<%= link_to("#{post.comments.size} comments", post_path(post)) %>
```

* Show all posts
```ruby
#posts_controller.rb
class PostsController < ApplicationController
  #...some code

  def index
    # retrive all posts and assign to instace then pass in view
    @posts = Post.all
  end
end
```

```erb
<!--index.html.erb-->
<ul>
  <% @posts.each do |post| %>
    <!--use post_path method and pass post for individual url-->
    <!--argument depends on params in routes url-->
    <li><%= link_to post.title, post_path(post) %></li>
  <% end %>
</ul>
```

### partials
* To render partial use render following by the partial name without _

```erb
<!--render partial _menu.html.erb and passing in varible to be used in partial-->
<%= render "menu", variable: variable %>
```

* Rendering Collections

```erb
<%= render partial: "product", collection: @products %>

<!--in _product.html.erb-->
<!--equivalent to each iteration-->
<p>Product Name: <%= product.name %></p>
```

* Rendering Collections shorthand

```erb
<!--assuming @products is a collection instances-->
<!--rails will find the partial by looking at the model in collection
in this case partial name is _product.html.erb-->
<%= render @products %>

<!--custom collection with each partial-->
<%= render [customer1, employee1, customer2, employee2] %>

<!--render collection from instances attributes-->
<!--partial _category.html.erb-->
<%= render @product.categories %>

<!--render collection with condition-->
<%= render(@products) || "There are no products" %>

render condition with html embed inside erb
<%= render(@post.categories) || "<h6>No category</h6>".html_safe %>
```