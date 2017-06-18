# Search form in rails
* HTTP sends a request to a URL, HTTP consists of:    
~> header, which contains a set of data about browser capabilities.  
~> body, which contains infomation for the server

* GET is a method requesting server to send back a resource.  
~> browser send empty body  
~> If a form is sent, the sent data will get appended to URL by name/value pairs.  
```
GET /?input_name=input_value&input_name2=input_value2 HTTP/1.1
Host: website.com
```

* POST is a method which asking for a response  
processed by the data provided from the body of HTTP request.  
~> When send a form the data included in the request body.  
```
POST / HTTP/1.1
Host: website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 13

input_name=input_value&input_name2=input_value2
```

* Rails search form should be GET  
~> action will point to search_path  
~> Use form_tag helpers to generate form  
~> Rails by default will include hidden input to collect params, need to that turn off.  
~> Ensure that rails submit helper has no name  

```ruby
#routes.rb
resources :videos, only: [:show] do
  collection do
    get "search"
  end
end
```

```ruby
#search form
.form-group
  = form_tag search_videos_path, enforce_utf8: false, method: "get" do
    = text_field_tag :query, nil, class: "form-control", placeholder: "Search goes here"
    = submit_tag "Search", name: nil, class: "btn btn-default"
```

```ruby
#video model
def self.search_by_title(string)
  return [] if string.blank?
  where("title LIKE ?", "%#{string}%").order("created_at DESC")
end
```

```ruby
#videos controller
def search
  @videos = Post.search_by_title(params[:query])

  render :search
end
```

```haml
<!--search display template-->
- @videos.each do |video|
  .video.col-sm-2
    = link_to video_path(video) do
      %img(src="#{video.small_cover}")
```