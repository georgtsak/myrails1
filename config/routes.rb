Rails.application.routes.draw do
  get 'static_pages/contact'
  devise_for :users
  # Defines the root path route ("/")
  # root "posts#index"
  get "/", to: "index#index"
  
  get "/posts/create", to: "posts#create"
  post "/posts/create", to: "posts#create"
  get "/posts/delete", to: "posts#delete"
  post "/posts/delete", to: "posts#delete"
  get "/posts/my", to: "posts#my"
  get "/posts/:id", to: "posts#show"
  get "/posts", to: "posts#index"

  get "/posts/categories", to: "categories#index"
  get "/posts/categories/:id", to: "categories#show"

  get "/messages", to: "messages#index"
  post "/messages/createconv", to: "messages#createconv"
  post "/messages/create", to: "messages#create"
  get "/messages/:id", to: "messages#show"

  get '/users/me', to: 'users#me'
  get '/users', to: 'users#index', as: 'users'

  post '/friends/new', to: 'friends#new'
  post '/friends/deny', to: 'friends#deny'
  post '/friends/accept', to: 'friends#accept'
  get '/friends/list', to: 'friends#list'
  get '/friends/pending', to: 'friends#pending'
  get '/friends', to: 'friends#index'

  resources :users, only: [:index, :show]
end
