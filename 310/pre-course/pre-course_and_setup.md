* Setup linux for window with vitualbox + ubuntu.  
~> view setup_guide.pdf   

* install postgresql
~> check guide  
~> access psql  `sudo -i -u postgres psql`  
~> `\l` list database, `\du` list roles  
~> `create role <appname> with createdb login password '<string_pass>';`  
~> exit postgresql `ctrl + d` then run `rails _4.1.1_ new app_name --database=postgresql`  
~> run `bundle` at project folder  
~> config `config/database.yaml`  
```ruby
development:
  adapter: postgresql
  encoding: unicode
  database: myapp_dev #config to app_name_dev
  host: localhost
  pool: 5
  username: myflix  #config to app name
  password: p053851238  #config to password

test:
  adapter: postgresql
  encoding: unicode
  database: myapp_test #config to app_name_test
  host: localhost
  pool: 5
  username: myflix  #config to app_name
  password: p053851238  #config to password
```
~> run `rake db:create:all`  
~> if error `no method last_comment` update `gem 'rspec-rails', '~> 3.5', '>= 3.5.2'` 

* (optional) db browsing  
~> Postico (Mac)  
~> pgAdmin (Linux)  

## Clone project guide
```
git clone https://github.com/gotealeaf/myflix
cd myflix
git remote -v
git remote set-url origin https://github.com/YOUR_GITHUB_USERNAME/myflix.git
git remote -v
git push origin master
```

* (optional) download zip, create repo, remote and push  
* if error `no acceptor`  
~> `ps ax | grep rails`  
~> `kill -9 <portnum>`  