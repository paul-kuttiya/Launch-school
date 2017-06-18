# Showing queue
## Show queue to user  
* Create routes for GET queue  
~> `get 'my_queue', to: 'queue_items#index'`  

* Create index view

## TDD for queue_items index
~> show queue items for user  
~> redirect for non user

* Create model for queue_items  
~> list_order, video_id, user_id  
~> user 1:M queue  
~> video 1:M queue

* Create queue_items controller  

* Re-implemented in the view  
~> shape the model method in view  
~> write TDD  
~> write model methods

* Use delegation helper in model method  
~> `delegate :category, to: video`  => .category will eq .video.category
~> `delegate :title, to: video, prefix: :video` => .video_title will eq .video.title

# Adding queue  
## Adding queue to video show page  
* Add queue button  
~> will be a link posted to queue items path  
~> need video_id for tracking videos in queue  
~> `link_to queue_items_path(video_id: @video.id)

* add create action and route for queue_items
~> `resources queue_items, only: [:create]`   

## TDD for queue_items controller  
* Test for post  
~> should add video to queue  
~> should redirect back to video page  
~> creates queue that has videos  
~> signed in user has own queue  
~> added video gets append to the queue  
~> won't add video again if already in queue  
~> will redirects back to sign in page for non-users