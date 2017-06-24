## spec Macros  
* will run before all specs  

* create `spec/support/macros.rb`  
~> create method for shared spec method   
~> such as: creating sign_in method for user  
```ruby
  def set_current_user(user=nil)
    session[:user_id] = (user || Fabricate(:user)).id
    session[:user_id]
  end
```

## shared_example  
* use for spec shared behavior result  
~> `spec/support/shared_examples.rb`  
```ruby
shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end
```

~> then define action in spec such as:
```ruby
it_behaves_like "requires sign in" do
  let(:action) {get :index}
end
```