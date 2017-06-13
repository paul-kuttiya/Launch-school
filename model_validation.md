## Model validations
* multiple presence validation  
`validates_presence_of :title, :description`  

* default scope  
`default_scope { order("name") }`
`default_scope { order(created_at: :desc) }`  

* order for association array  
~> `has_many :videos, -> {order("title")}`