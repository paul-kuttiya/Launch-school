## Spec test for videos controller

* create `spec/controllers/videos_controller_spec.rb`  

* follow 3 principles  
~> setup  
~> perform action  
~> verify result  

## Install test data ORM gem
* Install gems  
~> `gem 'fabrication'`    
~> `gem 'faker`  
~> run `bundle`

## Useful test tips
### fabricator and fake

* create `spec/fabricators/video_fabricator.rb`  
```ruby
Fabricator(:video) do
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(2) }
end
```

* create `spec/fabricators/user_fabricator.rb`  
```ruby
Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  full_name { Faker::Name.name }
end
```

### rspec matchers 
* `describe VideosController do`  
~> testing for videos_controller  

* `describe GET show do`  
~> test for GET from show controller  

* `context with auth users do`  
~> wrap context around each conditions for each action test in controller   

* if model has `before_action`, need to specify in context  
```ruby
before do
  session[:user_id] = Fabricate(:user).id
end
```

* `video = Fabricate(:video)`  
~> create fake data for video instance  

* `assigns(:video)`  
~> @video instance in describe controller#action  

* `get :show, id: video.id`  
~> get show action, pass id for show_path

* `expect(response).to render_template :show`  
~> no need to test since it is rails convention  
~> expecting response to render show template

* `expect(response).to redirect_to some_path`  
~> expect response to redirect

* `expect(...).to be_instance_of(Class)`  
~> expect setting obj to be instance of Model class

* `post :create, user: {...}`  
~> post to action, passing user obj to that action  

* `post :create, user: Fabricate.attributes_for(:user)`  
~> Frabricate attr for user without saving to DB  
~> Same as `User.new(attributes)`  

* `expect(flash[:notice]).not_to be_blank`  
~> check if something not blank  

* `expect(something).to be_nil`  
~> check if something is nil