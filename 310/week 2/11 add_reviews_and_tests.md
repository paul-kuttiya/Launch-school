## Add reviews
* Users and Videos will be 1:M relations with Reviews

* Create reviews migration  
~> will have description, rating, video_id, users_id, timestamps    
~> run `db:migrate`  

* create review model  
~> review belongs_to user and video  
~> user and video has_many reviews  

* Create some seed db for reviews  

* Add reviews to `video/show.html.haml`  

## Add review test
* Add review test controller in `spec/controllers/videos_controller_spec.rb`  
~> test show action, video instance has reviews for auth users