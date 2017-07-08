## set token for params[:id] url for rails 3 & 4
* rails 5 has `ActiveRecord secure token`  

* add migration to model  
~> `rails g migration add_token_to_users`  
~> `add_column :users, :token, :string`  to created migration file  
~> `rake db:migrate`  
```ruby
def change
  add_column :users, :token, :string
  #fix existing DB in migration  
  #not recommend for large DB
  #Use SQL for large DB
  User.all.each do |user|
    user.token = user.generate_token
    #make sure to check model validation to successfully save!
    user.save
  end
end
```

* by default in rails  
~> it calls ActiveRecord::Base `.to_param` to all `path()` helper at `link_to`  
~> `.to_param` calls id from model to generate url   
~> overwrite `.to_param` method to call on token instead  
~> use `before_create` and specify method to generate token  
~> `before_create` will generate once when create user  

```ruby
#models/user.rb
#other code
before_create :generate_token

def to_param
  token
end

def generate_token
  self.token = loop do
    random_token = SecureRandom.urlsafe_base64(nil, false)
    break random_token unless User.exists?(token: random_token)
  end
end
```

* fix show action or action that has params[:id]  
~> change find by id to find using token for model
```ruby
def show
  @user = User.find_by(token: params[:id])
end
```