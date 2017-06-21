## Reorder queue  
* Create a non-model backed form for all queues in queue index view   
~> will be complex form  
~> need to send data to server as `key: value_array`  
`queue_item: [{id: 1, list_order: 2}, ...]`  
~> need to form an array for element input use:  
=> `text_field_tag "name[][attribute]", value`  posted as #=> `name: [{attribute: value}]`  
~> need id attributes to post as well, use hidden input:  
=> `hidden_field_tag "name[][id]", value`  
~> need id and list_order for queue_items:  

```haml
  = hidden_field_tag "queue_item[][id]", queue.id
  = text_field_tag "queue_item[][list_order]", queue.list_order
```

~> full form for update queue:  
```haml
%section.my_queue.container
  .row
    .col-sm-10.col-sm-offset-1
      %article
        %header
          %h2 My Queue
        = form_tag update_queue_path, method: "post" do
          %table.table
            %thead
              %tr
                %th(width="10%") List Order
                %th(width="30%") Video Title
                %th(width="10%") Play
                %th(width="20%") Rating
                %th(width="15%") Genre
                %th(width="15%") Remove
            %tbody
              - @queue_items.each do |queue|
                %tr
                  = hidden_field_tag "queue_items[][id]", queue.id
                  %td= text_field_tag "queue_items[][list_order]", queue.list_order, class: "form-control"
                  %td= link_to "#{queue.video_title}", video_path(queue.video)
                  %td= button_to "Play", nil, class: "btn btn-default"
                  %td= queue.ratings
                  %td= link_to "#{queue.category_name}", queue.category
                  %td
                    = link_to queue, method: "delete" do
                      %i.glyphicon.glyphicon-remove
          = submit_tag "Update Queue", class: "btn btn-default"
```

* Assign update queue button for submit  

* Create route for update_queue  
~> `post "/update_queue", to: "queue_items#update_queue"`  

* Create controller for update_queue action  

* User model should order queue_items by list_order  
~> `has_many :queue_items, -> { order("list_order") }`  

* Create TDD context for update_queue action  
~> with valid input  
=> it redirects to my queue page  
=> it reorders queue items  
=> it nomalize list order  

~> with invalid input  
=> redirects to my queue page  
=> flashes message  
=> does not change queue items

~> with non user  
=> redirects back to sign in page

~> with queue items that does not belong to current user  
=> does not change the queue item

## Implemetation while TDD
* Use `reload` with TDD variable to pull of modify data when `expect(something)`

* To ensure `list_order` input is number only   
~> add validation in QueueItem model  
~> `validates_numericality_of :list_order, {only_integer: true}`  

* Use `begin` and `recue` with `def update_list`   
~> begin will execute the code  
~> use ! method to raise exception when validation fails  
~> if raise error will execute rescue  
~> `ActiveRecord::Base.transaction` ensures all validation inside the block passed, 
will roll back transaction to previous state if any failed.  
~> `rescue ActiveRecord::RecordInvalid` will rescue the invalid record/validation
```ruby
def update_queue
  begin
    update_queue_item
    normalize_queue_position
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "List order must be a number!"
  end

  redirect_to my_queue_path
end

private
#....
def update_queue_item
  queues_arr = params[:queue_items]
  ActiveRecord::Base.transaction do
    queues_arr.each do |queue|
      queue_item = QueueItem.find(queue["id"])
      queue_item.update_attributes!(list_order: queue["list_order"]) if current_user == queue_item.user
    end
  end
end

def normalize_queue_position
  current_user.queue_items.each_with_index do |queue, idx|
    queue.update_attributes(list_order: idx + 1)
  end
end
``` 