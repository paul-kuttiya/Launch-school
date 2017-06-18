## Add review routes 
~> add create reviews route under videos  
```ruby
#routes
resources :videos, only: [:show] do
  resources :reviews, only: [:create]

  #.....
end
```

* implement form in view
```haml
.row
  .col-sm-10.col-sm-offset-1
    = bootstrap_form_for [@video, @review], method: "post" do |f|
      = f.select :ratings, options_for_select([5,4,3,2,1].map {|n| pluralize(n, "Star")}), label: "Rate a video"
      = f.text_area :description, rows: 6, label: "Write a review"
      %fieldset.form-group.actions.clearfix
        = f.submit "Submit", class: "btn"
        = link_to "Cancel", @video
```
 
## Add TDD test for review controller   
* test for signed in users  
~> valid input  
~> invalid input

* test for not sign in users  

## Implement create action in reviews controller  
* build review instance using params[:review] from post request  
~> build method does not save to DB  
~> validates false and @review returns nil  
~> need reviews array to display existing reviews  
~> will get error for nil review in reviews arr, ie review.create_at ~> nil.created_at  
~> need reload to refresh instance, get rid of that @review in @video.reviews
```ruby
#create action in reviews controller
  @video = Video.find(params[:video_id])
  @review = @video.reviews.build(params[:review].merge!(user: current_user))

  if @review.save
    redirect_to @video
  else
    @video.reload
    render "/videos/show"
  end
```