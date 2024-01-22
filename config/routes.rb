Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/delete'
  devise_for :users
  # Defines the root path route ("/")
  # root "posts#index"
  get "/", to: "index#index"
  
  get "/posts", to: "posts#index"
  get "/posts/create", to: "posts#create"
  post "/posts/create", to: "posts#create"
  get "/posts/:id", to: "posts#show"

  get "/posts/categories", to: "categories#index"
  get "/posts/categories/:id", to: "categories#show"

  get "/messages", to: "messages#index"
  get "/messages/:id", to: "messages#show"

  get "/login", to: "login#index"
  get "/register", to: "login#register"
end
