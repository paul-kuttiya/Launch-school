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
~> `scenario '...', { js: true, vcr: true } do`  
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
~> `double = double(:name, )

### stub  
* a method stub is an instruction to an obj(real or test double) to return a known value(or nil).  

* stub is a method that stands in and fake for existing method, or method that not yet existed  
~> stub is a fake method generator, use with double  
~> rspec will use stub method, and stub return to run code and test, instead of the actual method defined  
~> use to test API or mocking method  
~> older syntax `obj.stub(:method).and_return(value)`  
~> new syntax `allow(obj).to receive(:method) { value }` or `allow(obj).to receive(:method).and_return(value)`  
~> `and_return` will return value for stub method  
~> if no `and_return` method or block after `receive(:method)` for stub, will return `nil`  

### Use stub and double implementation to test stripe API for user create action  
* Implement TDD 