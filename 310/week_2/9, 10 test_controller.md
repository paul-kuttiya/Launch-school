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

### fabricator and fake
* Fabricate gem will generate obj model each run  

* Faker gem will generate random attributes  
~> will be unique if wrapped in a block eg: `title {...}`

* create `spec/fabricators/video_fabricator.rb`  
```ruby
Fabricator(:video) do
#will generate unique wrapped in {...}
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(2) }
end
```

* create `spec/fabricators/user_fabricator.rb`  
```ruby
Fabricator(:user) do
  email { Faker::Internet.email }
  password: {Faker::Interet.password}
  full_name { Faker::Name.name }
end
```
* User fabricate in spec  
~> `Fabricate(:user)`  
~> This stores user obj in Database

* Overwrite fabricate in spec  
~> `Fabricate(:video, title: 'some title')`

## Useful test tips
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

* `expect(...).to be_instance_of(Class)`  
~> expect setting obj to be instance of Model class

* `post :create, user: {...}`  
~> post to action, passing user obj to that action  
~> post body will be each user[key] = value

* `post :create, user: Fabricate.attributes_for(:user)`  
~> Frabricate attr for user without saving to DB  
~> Same as `User.new(attributes)`  

* `expect(flash[:notice]).not_to be_blank`  
~> check if something not blank  

* `expect(flash[:notice]).to be_present  
~> check if something present

* `expect(something).to be_nil`  
~> check if something is nil  

* `let(:user) {Fabricate(:user)}`  
~> store user with value passsed in the method as block  
~> let will stored variable and can be in the same test context

```ruby
#videos_controller test
describe VideosController do
  describe 'GET show' do
    it 'sets @video for auth users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get 'show', id: video.id

      expect(assigns[:video]).to eq(video)
    end

    it 'redirects to sign in path for unauthenticated user' do
      video = Fabricate(:video)
      get 'show', id: video.id

      expect(response).to redirect_to sign_in_path
    end
  end

  describe "GET search" do
    it 'sets @videos for auth users' do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: 'video')
      get :search, query: "vid"

      expect(assigns[:videos]).to eq([video])
    end

    it 'redirects for unauthenticated users' do
      get :search, query: "video"

      expect(response).to redirect_to sign_in_path
    end
  end
end
```

```ruby
#users_controller test
describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns[:user]).to be_instance_of(User)
    end

    it "redirects user if signed in" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "valid users" do
      before do
        post :create, user: {full_name: 'abc', email: 'abc@gg.com', password: '1234'}
      end

      it "saves user" do
        expect(User.count).to eq(1)
      end

      it "stored user in session" do
        expect(session[:user_id]).not_to be_nil
      end

      it "shows notification" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end
  
    context "invalid users" do
      before do
        post :create, user: {email: 'abc@gg.com', password: '1234'}
      end

      it "sets user" do
        expect(assigns[:user]).to be_instance_of(User)
      end

      it "does not create user" do
        expect(User.count).to be(0)
      end

      it "render new template" do
        expect(response).to render_template :new
      end
      
      it "shows error" do
        errors = assigns[:user].errors.full_messages.size
        expect(errors).not_to be(0)
      end
    end
  end
end
```

```ruby
#sessions_controller test
describe SessionsController do
  describe "GET new" do
    it "renders new template for unautherized user" do
      get :new
      expect(response).to render_template(:new)
    end
    
    it "redirect to home page for authrorized user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "valid credentials" do
      let(:user) {Fabricate(:user)}
      before do
        post :create, email: user.email, password: user.password
      end
      
      it "stores user session" do
        expect(session[:user_id]).to be(user.id)
      end

      it "flash success message" do
        expect(flash[:success]).not_to be_blank
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end
    end

    context "invalid credential" do
      let(:user) {Fabricate(:user)}
      before do
        post :create, email: user.email, password: user.password + 'abcd'
      end

      it "does not store session" do
        expect(session[:user_id]).to be_nil
      end

      it "flash danger message" do
        expect(flash[:danger]).not_to be_blank
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context "GET destroy" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :destroy
      end

      it "destroys user sessions" do
        expect(session[:user_id]).to be_nil
      end

      it "shows sign out message" do
        expect(flash[:notice]).not_to be_blank
      end

      it "redirects to root" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
```