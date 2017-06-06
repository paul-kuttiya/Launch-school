PostitTemplate::Application.routes.draw do
  root to: 'todos#index'

  resources :todos, except: [:update]
end
