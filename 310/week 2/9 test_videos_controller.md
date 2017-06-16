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

* Fabricate gem will generate obj model each run  

* Faker gem will generate random attributes

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
* User fabricate in spec  
~> `Fabricate(:user)`  

* Overwrite fabricate in spec  
~> `Fabricate(:video, title: 'some title')`

# rspec matchers 
* `describe VideosController do`  
~> testing for videos_controller  

* `describe GET show do`  
~> test for GET from show controller  

* `context with auth users do`  
~> wrap context around each controller#action test  

* if model has `before_action`, need to specify in context  
```ruby
before do
  session[:user_id] = Fabricate(:user).id
end
```

* `video = Fabricate(:video)`  
~> create fake data for video instance  

* `assigns(:video)`  
~> @video instance in `describe GET show`   

* `get :show, id: video.id`  
~> get show action, pass id for show_path

* `expect(response).to render_template :show`  
~> no need to test since it is rails convention  
~> expecting response to render show template

* `expect(response).to redirect_to some_path`  
~> expect response to redirect

* `get :search, query: "vid"`  
~> get videos#search, pass query as 'vid'  
~> get url `search?query=vid`  

* run rspec by item  
~> `spec/controllers/videos_controller_spec.rb:28`