Myflix::Application.routes.draw do
  root 'pages#front'

  get '/home', to: 'videos#index'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  resources :videos, only: [:show] do
    resources :reviews, only: [:create]
    collection do
      get :search
    end
  end
  resources :categories, only: :show
  resources :users, only: [:create]

  get 'ui(/:action)', controller: 'ui'
end
