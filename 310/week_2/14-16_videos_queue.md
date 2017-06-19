# Showing queue
## Show queue to user  
* Create routes for GET queue  
~> `get 'my_queue', to: 'queue_items#index'`  

* Create index view  
~> show path can pass object directly without _path method  
~> `= link_to "#{@queue_item.category_name}", @queue_item.category`

## TDD for queue_items index
~> show queue items for user  
~> redirect for non user

* Create model for queue_items  
~> list_order, video_id, user_id  
~> user 1:M queue  
~> video 1:M queue

* Create queue_items controller  
~> index action  
~> @queue_items returns array of queue  
~> use `where` for array, `find_by` for single object

* Re-implemented in the view  
~> shape the model method in view  
~> write TDD  
~> write model methods

* Use delegation helper in model method  
~> `delegate :category, to: :video`  => .category will eq .video.category
~> `delegate :title, to: :video, prefix: :video` => .video_title will eq .video.title  

# Adding queue  
## Adding queue to video show page  
* Add queue button  
~> will be a link posted to queue items path  
~> need video_id for tracking videos in queue when posted   
~> `link_to queue_items_path(video_id: @video.id)

* add create action and route for queue_items
~> `resources queue_items, only: [:create]`   

* Create create action for queue_items controller

## TDD for queue_items controller  
* Test for post  
~> creates queue for user  
~> creates queue that has video for user   
~> added queue video gets appended to new queue for user    
~> should redirect back to video page   
~> signed in user has own queue     
~> won't add video again if already in queue  
~> will redirects back to sign in page for non-users

* implement create controller to satisfy TDD

# Removing queue
* create route for delete  
~> `resources queue_item, only: [:create, :destroy]`  

* Add delete path to view  
```haml
= link_to queue, method: "delete" do
  %span.icon.remove
```

* TDD for destroy action

* Add destroy to controller  
```ruby
def destroy
  @queue_item = QueueItem.find(params[:id])

  if @queue_item.destroy
    update_list
    redirect_to my_queue_path
  end
end

private
#...
def update_list
  current_user.queue_items.where("list_order > ?", @queue_item.list_order)
              .update_all("list_order = list_order - 1")
end
```

* Query for collection on condition  
~> `.where("key > ?", arg)`

* Update all parameter in collection  
~> `.update_all("condition")`  
~> `.update_all("list_order = list_order - 1")`  