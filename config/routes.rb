Rails.application.routes.draw do
  get 'static_pages/contact'
  devise_for :users
  # Defines the root path route ("/")
  # root "posts#index"
  get "/", to: "index#index"
  
  get "/posts", to: "posts#index"
  get "/posts/create", to: "posts#create"
  post "/posts/create", to: "posts#create"
  get "/posts/delete", to: "posts#delete"
  post "/posts/delete", to: "posts#delete"
  get "/posts/my", to: "posts#my"
  get "/posts/:id", to: "posts#show"

  get "/posts/categories", to: "categories#index"
  get "/posts/categories/:id", to: "categories#show"

  get "/messages", to: "messages#index"
  get "/messages/createconv", to: "messages#createconv"
  get "/messages/:id", to: "messages#show"
  
  get '/contact', to: 'contact#contact'
end
