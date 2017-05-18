# Active record migration & model
## migration
* Ruby DSL that change/define/create schema table without interecting directly with SQL.
* Each migration modifies DB: add/remove/change tables or columns.
* eg create users table command ~> **'rails generate migration create_users'**.

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

> virtual attributes ~> attributes that are given by association and not in the columns DB.