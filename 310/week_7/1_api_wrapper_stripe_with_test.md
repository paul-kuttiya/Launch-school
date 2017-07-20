## API wrapper for Stripe 
* create wrapper model for API  
~> to reuse an api and store at one place  
~> center in the wrapper and test only one place  

* create a wrapper in model  
~> `app/models/stripe_wrapper.rb`  

### TDD for wrapper model   
* create spec `spec/models/stripe_wrapper_spec`  

* `'describe ".create" do`  
~> it "makes a successful charge"  

* Implement for `".create"`  
~> for class method use `".create"`  
~> create charge card token obj with Stripe api  
```ruby
Stripe.api_key = ENV['STRIPE_SECRET_KEY']
#from stripe docs
token = Stripe::Token.create(
  card: {
    number: "4242424242424242",
    exp_month: 6,
    exp_year: Date.today.year + 1,
    cvc: 123
  }
).id
```
~> create response from stripe charge  
```ruby
response = StripeWrapper::Charge.create(
  amount: 999,
  source: token,
  description: "stripe charge"
)
```
~> expect stripe response amount to eq '999'  
~> expect stripe response currency to eq 'usd'  

## Setup VCR and webmock to record API response and use for test  
* VCR is a api recorder for rails  
~> record http interactions and reuse for test  
~> `gem 'vcr', '3.0.3'` in test   

* WEBMOCK is gem for setting expectation for rails request and `stubbing`  
~> `gem 'webmock'` in test  

* `bundle`  

* modify spec_helper and copy vcr configuration from vcr api  
~> `require 'vcr'` in the spec_helper  
```ruby
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  #... other code
  # so we can use :vcr rather than :vcr => true;
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true
end
```
~> run `rspec`, cassette will create api response file in specified folder in spec_helper config    
~> run vcr in spec by add `vcr` as extra argument   
```ruby
describe ".create" do
  it "charge customer", :vcr do
    #...
  end
end
```

## Featured Test with vcr and js  
* if page is run with JS, eg: submit form with JS  
~> need to turn on js and vcr when test  
~> test features spec with js integration, eg: post form with js  
~> set js and vcr test `scenario '...', { js: true, vcr: true } do`  
~> `gem 'selenium-webdriver'` and `gem 'database_cleaner'` in test in gemfile  
~> bundle  
~> tell vcr to ignore localhost  
~> turn off transactional fixtures in rspec  
~> config and register spec_helper Capybara driver to chrome  
~> config spec_helper capybara server to match selenium  
~> config mailer to match selenium port  
~> paste database_cleaner config to RSpec config  
~> delete cassette files to ensure new record for vcr when enable js  
```ruby
#spec_helper
#... other code

require 'vcr'

#register capybara selenium driver to chrome
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.javascript_driver = :chrome
#set capybara port to selenium port 
Capybara.server_port = 52662

VCR.configure do |c|
  #...
  #ignore localhost
  c.ignore_localhost = true
end

RSpec.configure do |config|
  #...
  #turn off transactionanl fixtures
  config.use_transactional_fixtures = false

  #database_cleaner config
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
 
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
 
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end
 
  config.before(:each) do
    DatabaseCleaner.start
  end
 
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```
```ruby
#config/environments/test.rb
#revise mailer port to match selenium
config.action_mailer.default_url_options = { host: 'localhost:52662' }
```

## Use stub and double  
### double  
* is a fake obj in test  
~> an obj that stands in for another obj during code testing sample  
~> set double to desired behavior by specified the return for desired_method  
~> double name should match instance name which double from  
~> `double = double(:name, response_to_method: return_value)`  
~> eg: `double = double(:charge, successful?: false)`  
```ruby
# set charge double to stand in for charge obj
# set double to have method successful? and return false for successful?
# set double to have method error_message and return "message"
charge = double(:charge, successful?: false, error_message: "message")

# expect StripeWrapper::Charge to excecute create method and return charge double   
expect(StripeWrapper::Charge).to receive(:create) { charge }
```

### stub  
* a method stub is an instruction to an obj(real or test double) to return a known value(or nil).  

* stub is a method that stands in and fake for existing method, or method that not yet existed  
~> stub is a fake method generator, use with double or existing obj   
~> rspec will use stub method, and stub return to run code and test, instead of the actual method defined  
~> use to test API or mocking method  
~> older syntax `obj.stub(:method).and_return(value)`  
~> new syntax `allow(obj).to receive(:method) { value }` or `allow(obj).to receive(:method).and_return(value)`  
~> `and_return` will return value for stub method  
~> if no `and_return` method or block after `receive(:method)` for stub, will return `nil`  

### should_receive, expect to receive
* old: `obj.stub(:method).and_return(value)` or new: `allow(obj).to receive(:method) {return value}`, calling method is optional when test run  
~> use `obj.should_receive(:method).and_return(double)`, new: `expect(obj).to receive(:method) {return}` to strictly test that the method is run and return value as desired  
~> expect obj to run excecute method and return something  

### Use stub and double to implementation and test stripe API for user create action  
* Revise and implement TDD  

* happy path:   
~>  
context "valid personal info and valid card"  
~> #... other tests  

* non happy path:  
~>  
context "valid personal info and decline card"  
~> it "does not create new user record"  
=> double "charge"  
=> stub `stripeWrapper::Charge(:create)` set return value to charge   
=> post to create with user info and stripeToken  
=> expect User count to eq 0  
~> it "renders new template"  
~> it "sets flash error message"  
~>  
context "invalid personal info"  
~> #... other tests
~> it "does not charge the card"  
=> `StripeWrapper::Charge` should not receive create method  
=> post to the server with invalid input   

* implement for TDD  
~> revise use to validate instead of save when submit form `@user.valid?`  
~> if valid info, charge card and set instance charge   
~> if charge.successful?, save info, else render and flash  
~> fix test, implement double and return for successful?  
~> revise test from stub to `obj.should_receive(:create)`, __new syntax:__ `expect(obj).to receive(:method)`  
~> implement the desired methods(successful?) in `StripWrapper` model  
~> implement `StripWrapper` model test for the desired method  

* `StripeWrapper` model TDD  
~> it "makes a successful charge", :vcr  
=> expect response to be_successful, hit api and get back response  
=> create new instance if response is succeed  
=> capture response with initialize in hash(named arguement)   
~> it "makes a card declined a charge", :vcr  
=> use invalid card "4000000000000002"  
=> expect response not to be successful  
=> stripe will throw error, capture exception with `begin`, `rescue`  
~> it "returns the error message for declined charges"  
=> expect response.error_message to eq "Your card was declined"  
=> capture error_message with initialize method in hash   

* move `Stripe.api_key = ...` to `config/initializers/stripe.rb`  
~> `config/initializers` files will loaded when rails start and store configurations  

### expect(obj).to receive(:method)
* rspec will run and check if the method is execute  
```
#errors sample, expect method to execute 1 time but excecuted 0 time
expected: 1 time with any arguments
received: 0 times with any arguments
```

* similary `expect(obj).not_to receive(:method)`  
~> expect method not to excecute  
```ruby
#sample test
it "does not charge the card" do
  #expect create method not to be excecuted from Stripe API
  expect(StripeWrapper::Charge).not_to receive(:create)
end
```