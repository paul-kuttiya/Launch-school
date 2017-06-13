# Testing  
* general testing has 3 types  
~> unit testing; models, views, routes  
~> function testing; controllers  
~> integration testing; buiness, users interaction

### Rspec

* install rspec-rails  
~> gem 'rspec-rails'

* configure in Gemfile
```ruby
  group :test, :development do
    gem "rspec-rails"
  end
```

* run `bundle`

* run `rails g rspec:install`

#### Test for models

* create folder models inside spec folder  
~> `/spec/models/model_name_spec.rb`  

* load spec env and associating class  
~> `require 'spec_helper'` 

* Create test using specification philosophy steps  
~> describe something  
~> spicified what it should do  
~> include the test  

* Tests consist of 3 steps:  
~> setup the data, state  
~> perform action  
~> verified results
```ruby
  describe Todo do
    it "save itself" do
      #1 setup
      todo = Todo.new(name: "cook")

      #2 perform action
      todo.save

      #3 verified result
      expect(Todo.first.name).to eq("cook")
    end
  end
```

* run rspec in project root folder  
~> `rspec`

#### Test DB
* Create test schema by running migration for test db  
~> `rake db:migrate db:test:prepare`