## Concern  
* a way to extract ruby codes in rails to module  
* be able to include in other files for reusable  

* steps  
~> create file name in `./lib/module_name.rb`  
~> ie: `./lib/tokenable.rb`  
~> extend `ActiveSupport::Concern`  
```ruby
#Tokenable
module Tokenable
  extend ActiveSupport::Concern

  #class methods
  module ClassMethods
    #context is already class scope, do not need to specified self
    def token
      #...
      #no self in here too, already same context
    end
    #...
  end

  #callbacks
  included do
    has_many :tags
  end

  #instance method
  def method
    #need self for writer method still
    #...
    self.value = new_value
  end
end
```

~> include `Tokenable` in the file   
```ruby
#user.rb
#...
include Tokenable
```

~> config auto load part at `config/application.rb`  
```ruby
  module AppName
    class Application < Rails::Application
      #...
      config.autoload_paths << "#{Rails.root}/lib" 
    end
  end
```