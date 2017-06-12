Myflix::Application.routes.draw do
  root to: 'videos#index'
  get '/home', to: 'videos#index'
  
  resources :videos, only: [:index, :show]
  resources :categories, param: :name,  only: [:show]

  get 'ui(/:action)', controller: 'ui'
end
