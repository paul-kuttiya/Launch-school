## Decorators  
* Use when present model differently on the webpage   
~> seperate presentation logic regarding model that use on the view  

* use `gem draper` for easy decorators creation  
~> a wrapper wraps around model with presentation logic    

## Move video rating into decorator  
* create `app/decorators/decorator_name.rb`  
~> `app/decorators/video_decorator.rb`  
~> define presentation logic in decorator  
~> in controller#action set instance to video decorator class instead of model, call decorator to create new instance    
```ruby
#video controller
def show
  @video = VideoDecorator.decorate(Video.find(params[:id]))
end
```
~> delegate method in decorator to model  
~> in decorator class, instance that create from model and pass in `Decorator.decorate(@video)` will refers as `object`  
```ruby
class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating.present? ? "Rating #{object.ratings}/5.0" : "No Reviews"
  end
end
```