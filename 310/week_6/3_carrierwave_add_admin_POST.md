## Add admin POST  
* post to `/admin/videos`  
* add routes create to `namespace :admin`  

### TDD 
* Test POST create  
~> it_behaves_like 'requires sign in'  
~> it_behaves_like 'requires admin'  
~>  
context "with valid inputs"  
~> it "creates a video"  
~> it "redirects to add video page"  
~> it "sets the flash success message"  
~>  
context "with invalid inputs"  
~> it "does not create a video"  
~> it "renders a new template"  
~> it "sets the errors array message"  

* implementation  
~> implement shared example it_behaves_like 'requires admin'  
~> implement create action  

## Add carrierwave  
* add carrierwave for uploading and mini_magick for image processing  
~> `gem 'carrierwave'` and `gem 'mini_magick'` then `bundle`  

* use rails form_helper to generate file field  
~> `f.file_field :large_cover, class: "btn btn-file"`  
~> `f.file_field :small_cover, class: "btn btn-file"`  

* generate migration for cover path  
~> `rails g migration add_cover_to_videos`  
```ruby
#migration file if not yet exists
def change
  add_column :videos, :large_cover, :string
  add_column :videos, :small_cover, :string
end
```
~> run `rake db:migrate`  

* mount uploader in the model  
```ruby
#video model
mount_uploader :large_cover, LargeCoverUploader
mount_uploader :small_cover, SmallCoverUploader
```

* Create uploaders with associated class   
~> create `app/uploaders`  
~> create `app/uploaders/large_cover_uploader.rb` and `app/uploaders/small_cover_uploader.rb`  
~> inherit from class carrierwave  
~> use minimagick to process image with specified size  
```ruby
#inside uploader files
class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  process resize_to_fill: [665, 375]
end
```
```ruby
class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  process resize_to_fill: [166, 236]
end
```

* [optional] use command `rails g uploader [--name]`  
~> will generate `app/uploaders/name_uploader.rb`  
~> will subclass from carrierwave `class NameUploader < CarrierWave::Uploader::Base`  

* Setup carrierwave to upload to AmazonS3  
~> setup aws policy on aws account  
~> install ImageMagick locally for local uploading  
~> `gem carrierwave-aws` then bundle  
~> create carrierwave initializer `config/initializers/carrier_wave.rb`  
~> copy cofiguration to the file  
~> use heroku env to store aws credentials, DO not hard code in file  
```ruby
CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :aws
    #code
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end
```

## For seed data
* move seed image to `app/assets/images/`  
* use image path to point to images folder with open method  
* assign image_path to image key in seed instance  
```ruby
def image_path(file)
  Rails.root.join("app/assets/images/#{file}").open
end

image_path = Rails.root.join("app/assets/images/monk.jpg").open

20.times do
  Fabricate(:video, 
    category: Category.all.sample, 
    small_cover: image_path("monk.jpg"), 
    large_cover: image_path("monk_large.jpg")
  )
end
```