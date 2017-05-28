# Polymorphic

* Polymorphic could be associate with anything

* One to many association to User

* Polymorphic association to any other type

* Composite foreign key(2 column to track fk)  
~> Have string keep tracks of the type: `...able_type`  
~> Have id track type id `...able_id`  

* ### _[Polymorphic table sample](./polymorphic_tables.jpg)_

## Create Polymorphic Votes

* ### _[Votes association diagram](./ERD_final.jpg)_

* generate migration  
~> `rails g migration create_votes`

```ruby
class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.boolean :vote
      t.integer :id
      t.integer :user_id
      t.string :voteable_type
      t.integer :voteable_id
      t.timestamps
    end
  end
end
```

* ~> `rake db:migrate`

* create votes model
```ruby
#user.rb
#additional code
has_many :votes
```

```ruby
#vote.rb
class Vote < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  
  #define polymorphic many-side, rails will look for voteable type and id
  #rails will generate voteable getter and settle
  belongs_to :voteable, polymorphic: true
end
```

* Define one-side on polymorphic model that will be voted for
```ruby
#post.rb
#additional code
has_many :votes, as: :voteable
```

```ruby
#comment.rb
#additional code
has_many :votes, as: :voteable
```

* Define POST routes for `/posts/:id/vote` and `/comments/:id/vote`  

```ruby
#routes.rb
#modify code
resources :posts, except: [:destroy] do
  #every members ~> posts/:id
  member do
    #POST route only for /vote on posts route members ~> /posts/:id
    post :vote # => controller posts#vote
  end
end
```

* Implement votes in View  
~> pass post obj in `vote_post_path method`  
~> pass additional params key, value pair for vote boolean in `vote_post_path method`   
~> use link to upvote `POST /posts/:id/vote?vote=true`  
~> use link to downvote `POST /posts/:id/vote?vote=false`  

```erb
<!--add code in _post view-->
<div class="row">
  <div class="span0 well text-center">
    <!--post is the obj for individual post-->
    <%= link_to vote_post_path(post, vote: true), method: 'post' do %>
      <!--wrapping a tag with element-->
      <i class="icon-arrow-up"></i>
    <% end %>
    <%= link_to vote_post_path(post, vote: false), method: 'post' do %>
      <i class="icon-arrow-down"></i>
    <% end %>
  </div>
</div>
```

* implement vote action in Posts controller

```ruby
#posts_controller
#additional 

before_action :set_post, only: [:vote, ...]
def vote
  #No need to do the CRUD implement, only POST link
  #votable: virtual attributes will set post obj to vote
  #creator: for set user_id
  @vote = Vote.create(votable: @post, creator: current_user, vote: params[:vote])

  #.valid? ~> ActiveRecord method, returns true if no errors
  if @vote.valid?
    flash[:notice] = "Voted"
  else
    flash[:error] = "Error"
  end

  redirect_to :back
end

#...
private
def set_post
  @post = Post.find(params[:id])
end
```

* Add methods for showing votes total in Model  
~> Business logic with data goes into model  

```ruby
#Models/post.rb
#additonal code
def total_votes
  up_votes - down_votes
end

def up_votes
  #where is ActiveRecord method
  self.votes.where(vote: true).size
end

def down_votes
  #where is ActiveRecord method
  self.votes.where(vote: false).size
end
```

* implement model method to view
```erb
<!--add code in _post view-->
<div class="row">
  <div class="span0 well text-center">
    <!--post is the obj for individual post-->
    <%= link_to vote_post_path(post, vote: true), method: 'post' do %>
      <!--wrapping a tag with element-->
      <i class="icon-arrow-up"></i>
    <% end %>
    <br>
    <%= post.total_votes %>
    <br>
    <%= link_to vote_post_path(post, vote: false), method: 'post' do %>
      <i class="icon-arrow-down"></i>
    <% end %>
  </div>
</div>
```

* sorted post
```ruby
#posts_controller.rb
#additional code
def 
  #limited @posts array before sort_by would be better
  @posts = Post.all.sort_by{|x| x.total_votes}.reverse
end
```

* user can only vote post single time for each post  
~> validates association for specific scope  
~> validates uniqueness of creator for voteable scope
```ruby
#models/vote.rb
#additional code
validates_uniqueness_of :creator, scope: :voteable
```
