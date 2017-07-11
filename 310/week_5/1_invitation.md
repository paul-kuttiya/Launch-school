> belongs_to association does not need to specify for foreign key(foreign_key is already a column in DB)  
---
> has_many need a foreign key to look for the associated data in the model.  
ie: user has_many :reviews, need user_id for User to look for user's review in reviews db 

## create invitation
* create view for invitation  
~> create get and post routes  
~> `resources :invitations, only: [:new, :create]`  
~> create invitations controller  
```haml
<!--model backed form-->
= bootstrap_form_for @invitation do |f|
  = f.text_field :recipient_name, label: "Friend's Name"
  = f.text_field :recipient_email, label: "Friend's email"
  = f.text_area :message, label: "Message"
```

### TDD for invitations controller "GET new"   
~> it "sets @invitation to a new invitation"  
~> it_behaves_like "requires sign in"  

* Implement for TDD  
~> create new invitation model and migration  
~> need `:inviter_id` for self association  

### TDD for invitations controller "POST create"  
~> it_behaves_like "requires sign in"  

~>  
context "valid inputs"    
~> it "redirects to invitation page"  
~> it "creates an invitation"  
~> it "sends email to the recipient"  
~> it "sets flash message"  

~>  
context "invalid inputs"  
~> it "renders new template"  
~> it "does not create invitation"  
~> it "does not send out email"  
~> it "sets @invitation errors" (for errors displaying)

* Implement for TDD  
~> new Invitation, merge! inviter_id: current_user.id, then save  
~> send invitation email  
~> create send_invitation_email(invitation) method in app_mailer  
```ruby
#app_mailer
def send_invitation_email(invitation)
  @invitation = invitation
  mail to: invitation.recipient_email,
       from: "info@myflix.com",
       subject: "Please join myfilx" 
end
```
~> create template for send_invitation_email action  
```haml
%html
  %body
    %p You are invited by #{@invitation.inviter.full_name}
    %p= @invitation.message
    = link_to "Accept", "#"
```
~> set association  
```ruby
#invitation.rb
belongs_to :inviter, class_name: "User"
#for invalid inputs context TDD
validates_presence_of :recipient_name, :recipient_email, :message
```

~> TDD in invitation model

## create user register with token  
* implement invitation email link to go to user route `/register/#{token}`   
~> `link_to "Accept", register_with_token_url(@invitation.token)`

* implement register with token route  
~> `get /register/:token, to: "user#new_with_invitation_token", as: "register_with_token"`  

* create token for invitation with before_create  
```ruby
before_create :generate_token

def generate_token
  #same as user
end
```

### TDD GET new_with_invitation_token  
~> it "renders the new template"  
~> it "sets @user with recipient's email"  
~> it "sets @invitation_token  
~> it "redirects to expired token page for invalid tokens"  

* implementation for "GET new_with_invitation_token"  
~> create Fabricator for invitation  
~> render new template  
~> find invitation instance from params[:token]  
~> set user from invitation instance, with recipient email,  
to show email in the :new form when visited  
~> redirect to expired token page if user is not found  

* Track who is inviter by add token in user registration field  
~> the info does not nessessarily need to be posted under user params   
~> use `hidden_field_tag` instead of `f.hidden_field`  
~> add `hidden_field_tag :invitation_token, @invitation_token`  

## implement TDD in users_controller POST create  
* implement under valid inputs context   
~> it "makes the user follow the inviter"  
~> it "makes the inviter follow the user"  
~> it "expires the invitation upon acceptance", can only accpet once  

* implement user controller create action  
~> make user follow inviter if token present  
~>  
create follow(another_user) method for user  
it "follows another user"  
it "does not follow one self"  
```ruby
#user.rb
def follow(another_user)
  # add to new following_relationships array with foreign_key set to instance itself
  following_relationships.create(leader: another_user) if can_follow?(another_user)
end
```

~> make inviter follow user if token present  
~> update invitation column to be nil  
~> refactor some code to private method  
~> move expired token to page expire for generic use  
~> clear email in feature tests  

## Feature specs
* test happy path  
~> scenario "user sucessfuly invites friend and invitation is accepted"  
~> clear email