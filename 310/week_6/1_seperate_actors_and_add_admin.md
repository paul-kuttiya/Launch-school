## Seperate actors  
* add namespace in routes  
~> will create new routes and controller for that actor  
```ruby
#routes
namespace :admin do
  resources :todos, only: [:index]
  #admin_todos    /admin/todos   admin/todos#index
end
```
~> add admin boolean column in migration  
~> controller will be `controllers/admin/todos_controller.rb`  
```ruby
class Admin::TodosController < ApplicationController

end
```

* for complex app with multiple namespace controller name  
~> create a new controller `admins_controller.rb`  
```ruby
#/controllers/admins_controller.rb
class AdminsController < ApplicationController
  before_filter :only_admin

  def only_admin
    redirect_to root_path unless current_user.admin?
  end
end
```
~> refactor admin_namespace controller to inherit from admins_controller  
```ruby
#controllers/admin/todos_controller.rb
class Admin::TodosController < AdminController
end
```

~> refactor controller that need authenticate to authenticated_controller  
```ruby
#controllers/authenticated_controller.rb
class AuthenticatedController < ApplicationController
  before_filter :require_user
end
```
```ruby
#refactor todos_controller to inherit from authenticated_controller
#before_filter in AuthenticatedController will apply for TodoController
class TodosController < AuthenticatedController
#...
end
```