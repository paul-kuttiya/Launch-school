## Carrierwave  
* A ruby gem to upload file, use with image processing library `Imagemagick`  
~> add `gem 'carrierwave'` to gemfile then `bundle`    
~> add `gem 'mini_magick'` to gemfile then `bundle`  
~> use `uploader` for file uploading  

* when generate uploader with rails command  
~> `rails generate uploader Avatar`  
~> will generate a file in `app/uploaders/avatar_uploader.rb`  
~> will create a class `AvatarUploader` and inherit from `Uploader::Base` class  
~> use carrierwave API for integration  