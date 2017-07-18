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
~> add actor namespace to controller class  
~> `Actor::Controller_name`   
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

## Implement admin myflix  
* only admin can add videos  

* Create a view and routes and controller   
~> view `admin/videos/new.html.haml`  
~> admin namespace route  
```ruby
namespace :admin do
  resources :videos, only: [:new]
end
```
~> controller `/controllers/admin/videos`  

* form will be a model-backed form  
~> post to `/admin/videos`  
~> refer array to post url `bootstrap_form_for [:admin, @video], html: {class: '...'}`  
~> use rails helper select box for category `options_for_select([['name', 'value'], [...], ...]) 
```haml
= f.select :category_id, options_for_select(Category.all.map { |cat| [cat.name, cat.id]})
```

### TDD for admin/videos_controller.rb controller 'GET new'   
* tests requirement  
~> it_behaves_like 'requires sign in'  
~> it_behaves_line 'requires admin`    
~> it 'sets @video to a new video'  
~> it 'redirects regular user to home path'  
~> it 'sets error flash for regular user'  

* test implementation  
~> add admin boolean column to users table  
~> add admin? method to user model  
~> add set_current_admin to test macros  
~> add admin to Fabricator  
```ruby
#user fabricator
Fabricator(:user) do
#...
  admin false
end

#inherit attributes from user Fabricator
Fabricator(:admin, from: :user) do
  admin true
end
```