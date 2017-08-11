# Testing  
* general testing has 3 types  
~> unit testing; models, views, routes  
~> function testing; controllers  
~> integration testing; buiness, users interaction

### Rspec v.2.99
* install and configure in Gemfile
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
```ruby
# .rspec
--color
--require 'spec_helper'
```

* Create test using specification philosophy steps  
~> describe something  
~> spicified what it should do  
~> include the test  

* test model methods which are our codes
~> no need user sign in  

* test rails model association by shoulda gems

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
#### Test DB
* Create test schema by running migration for test db  
~> make sure `rake db:migrate` is run  
~> `rake db:test:prepare`

* run rspec in project root folder  
~> `rspec`

### Shoulda matcher
* Real testing environment should test only our code not rails  
~> using shoulda matcher for rails function that our code implemented with   
~> test declaration of our code  
~> come with methods that tests common rails functionality; matchers  
~> matchers methods can be checked on git repo

* install shoulda matcher
```ruby
  group :tests do
    gem 'shoulda-matchers'
  end

  #run bundle
```

* use shoulda for code testing
```ruby
  describe Video do
    it { should belong_to(:category) }
    it {  }
  end
```

### TDD
* Test driven development  
~> Write test as objective then implement code to match objective  
