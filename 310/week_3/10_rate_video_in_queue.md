## queue_items view

* reuse dropdown options in queue_items view from show  
~> implement in helpers  
~> default value to nil for no review  
~> if selected not nil, the value will be displayed in the form  
```ruby
#application_helper.rb
def options_for_video_review(selected=nil)
  options_for_select([5,4,3,2,1].map {|n| [pluralize(n, "Star"), n]}, selected)
end
```

* Modify queue_items view form to include dropdown for ratings  
~> pass instance ratings to show existing value  
~> `include_blank: true` for showing blank dropdown at `nil` value  
~> `%td= select_tag "queue_items[][ratings]", options_for_video_review(queue.ratings), include_blank: true`

## queue_items controller
* implement update_queue_item action  
~> `queue.update_attributes(..., ratings: new_ratings)`  
~> `queue.update_attribute` will save new data to DB  
~> `ratings: new_ratings` inside `queue.update_attributes` 
will call upon setter method `ratings` from QueueItem model  
~> need to create setter method(virtual attributes) for QueueItem 
to make `update_attributes` work(already has reader implemented btw)  
~> `def rating=(new_rating)`  

* TDD for `#rating=`  
~> it changes review if already presented  

~> it clears review if already presented  
=> use `instance.update_column(:column, value)` to bypass model validation   

~> it creates a review if not presented  
=> if review from queue_item page need to `review = Review.new(...)`, 
then save to DB bypassing validation `review.save(validate: false)`   

* Refactor, use memorization if needed, call from instance instead of jumping in DB everytime. 

* Fix broken TDD.  

* getter for review needs to be specific,
need to find by user and video.  
```ruby
def review
  @review ||= Review.find_by(user: user, video: video)
end
```