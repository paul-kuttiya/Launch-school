# Association  
* by default rails will build a method from association and look for query in db 
when specified `has_many` or `belongs_to` 
```ruby
#class Relationship
#joined table for follower and leader
belongs_to :follower, class_name: "User"
belongs_to :leader, class_name: "User"

def follower
  User.find_by(id: follower_id)
end

def leader
  User.find_by(id: leader_id)
end
```

```ruby
#class User
has_many :followering_relationships, class_name: 'Relationship', foreign_key: 'follower_id'
has_many :leading_relationships, class_name: 'Relationship', foreign_key: 'leader_id'
has_many :reviews

def followering_relationships
  Relationship.where(follower_id: id)
end

def leader
  Relationship.where(leader_id: id)
end

def reviews
  Reviews.where(user_id: id)
end
```

* not working if not specified class_name: "User", or "foreign_key"
```ruby
#class Relationship
belongs_to :follower
belongs_to :leader

def follower
  Follower.find_by(id: follower_id)
end

def leader
  Leader.find_by(id: leader_id)
end
```

```ruby
#class User
has_many :followering_relationships

def followering_relationships
  Followering_relationship.where(user_id: id)
end
```

## Create self association
### Create people page; index for relationship
* Create view `views/relationships/index.html.haml`  

* Create controller `relationships_controller`  

* Make view dynamic and create TDD for relationship controller `GET index`  
~> `it "sets @relationship to array of relationships which user is following"`  
~> `it_behaves_like 'requires sign in'`  

* `DELETE destroy`  
~> `it_behaves_like "requires sign in"`  
~> `it deletes follower relationship for following user`  
~> `it redirects to the people page`  
~> `it does not delete relationtship if a user is not a follower`  

* In TDD process  
~> create get people route `get '/people', to: 'relationships#index'`  
~> create delete route `resources :relationships, only: [:delete]`   
~> create joined self refernece relationships migration `leader_id, follower_id, timestamps`   
~> relationships table will return user instance for each query  
~> create relationship model  