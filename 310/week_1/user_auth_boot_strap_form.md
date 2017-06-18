## User auth
* install gems  
~> bcrypt  
~> bootstrap_form

* create migration for users
~> `rails g migration users`  
~> create column for full_name, email, password_diget as string  
~> `rake db:migrate`

* create route  
~> sign_in  
~> register  
~> create for sign_in and register

```ruby
#route.rb
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'

  resources :users, only: [:create]
  resources :sessions, only: [:create]
```

* create model for user  
~> set validates, uniqueness  
~> has_secure_password

* create controller for users, sessions

* create view for 
~> register: users#new   
~> sign_in: sessions#new  

```haml
<!--register view-->
= bootstrap_form_for(@user, layout: :horizontal, | 
label_col: "control-label col-sm-2", control_col: "col-sm-6") do |f|
  %header
    %h1 Register
    = f.email_field :email, label: "Email Address"
    = f.password_field :password
    = f.text_field :full_name, label: "Full Name"
    = f.form_group label_col: "col-sm-offset-2" do
      = f.submit "Sign Up", class: "btn btn-default" 
```

```haml
<!--register view-->
<!--sign_in view => sessions-->
= bootstrap_form_tag url: sessions_path, class: "sign_in" do |f|
  %header
    %h1 Sign in
    .row
      .col-sm-4
        = f.email_field :email, label: "Email address"
    .row
      .col-sm-4
        = f.password_field :password
  = f.form_group do
    = f.submit "Sign in", class: "btn btn-default"
```

* create action for create in sessions and users controller  
~> handle post request from form

* create action for destroy in sessions controller  
~> set session to nil when GET request from logout link  

* denied access when user sign_in / register for:  
~> GET login  
~> GET register  
~> landing pages