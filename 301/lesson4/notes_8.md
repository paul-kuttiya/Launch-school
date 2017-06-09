# Exposing API
* use `response_to` method and render json for instances

```ruby
  response_to do |format|
    #JSON
    formant.json do
      #by default will call .to_json to obj
      render json: @post
    end

    #XML
    formant.xml {render xml: @post}
  end
```

# Refactoring with module
* module will create mixins after the class lookup for class instances  

* Edit `application.rb` and insert `autoload_paths` on line 14.   
~> autoload will load the module files in the specified folder when rails starts

```ruby
  config.autoload_paths += %W(#{config.root}/lib)
```

* Inside '/lib' create a module file and module  
~> include ModuleName inside the class for mixins 

```ruby
#lib/voteable.rb
#file snake_case, name CamelCase,
module Votable
  #must require
  extend ActiveSupport::Concern

  #Hook => execute once when module is included in the class
  included do
    has_many :votes, as: :voteable
  end

  def instance_method
  end

  #ActiveSupport::Concern to define class method for module
  module ClassMethods
    def some_class_method
    end
  end
end
```

# Gem
### Create and host gem in railsgems.org
* Need `gemcutter (0.7.1)`

* Create gem folder  
~> Create _gemname_gem_ folder  
~> Create _gemname.gemspec_ file

```ruby
Gem::Specification.new do |s|
  s.name = "voteable_pkuttiya"
  s.version = "0.0.0"
  s.date = "2017-05-31"
  s.summary = "A voting gem"
  s.description = "Voting gem"
  s.authors = ['Paul Kuttiya']
  s.email = 'w.kuttiya@gmail.com'
  s.files = ['lib/voteable_paul_kuttiya.rb']
  s.homepage = 'http://github.com'
end
```

* create `lib/voteable_pkuttiya.rb` file  
~> create the code for gem file  
~> from the gem folder run `gem build gem_name.gemspec` in console
~> run `gem push gem_name-version.gem` in console

### Pull and use gem from railsgem.org
* include gem_name in Gemfile  
~> run `bundle install`  
~> require the file name to use application wide in `application.rb`  
~> `include ModuleName` inside the class for mixins

* Testing the gem locally  
~> include the path after gem in Gemfile  
=> `gem 'something', path: 'local_path'`  

# Pagination
* use `limit` and `offset`  
~> define PER_PAGE constance in class controller  
~> display pagination with link_to in view  
~> use extra params passed in `_path(`) helper  
~> handle in controller

* Define `default_scope` in model to set default for instances  
```ruby
#Post model
#additional code

default_scope { order('created_at ASC') }
```

