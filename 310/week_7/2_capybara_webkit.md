## Feature test webkit  
* capybara will use selenium to run chrome and test js  
~> selenium slowest of js runner  

* [optional] capybara-wepkit  
~> faster than selenium  
~> test: `gem 'capybara-webkit'`  
~> need to install qt locally into machine before use  
~> set `Capybara.javascript_driver = :webkit` in `spec_helper`  
~> js test will run in background  
~> if needed to run on selenium enable selemium `scenario "something", driver: :selenium do`