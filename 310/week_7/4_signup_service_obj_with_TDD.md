## Service object  
* A OOP way to extract logic for services  

* Service object for user signup
~> put the class in `services/service_obj_name.rb`  
~> define class in service obj and refactor logic from controller to service obj, eg `UserSignup`  
~> move user validation, stripe and invitation to obj service  
~> in controller use a service obj class and pass needed arg for stripe and invitation in the service obj class  
~> set instance variable to capture state, eg: @status, @error_message and return self in instance method  
~> check the condition from instance created from service_obj class and set controller to response accordingly  
~> refactor test in user controller to concern only controller level  
~> create TDD for service obj level  
