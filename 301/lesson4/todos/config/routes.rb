PostitTemplate::Application.routes.draw do
  root to: 'todos#index'

  resources :todos do
    member do
      post :completed
    end
  end

  
  resources :users, only: [:show, :edit, :update] do
    member do
      post :clear, as: 'clear_todos'
    end
  end

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
