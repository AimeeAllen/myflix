Myflix::Application.routes.draw do
  root 'pages#front'

  get '/home', to: 'videos#index'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/my_queue', to: 'queue_items#index'

  resources :videos, only: [:show] do
    resources :reviews, only: [:create]
    collection do
      get :search
    end
  end
  resources :categories, only: :show
  resources :users, only: [:create]
  resources :queue_items, only: [:create, :destroy]

  get 'ui(/:action)', controller: 'ui'
end
