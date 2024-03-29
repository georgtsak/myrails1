Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register", omniauth_callbacks: 'users/omniauth_callbacks' }

  get 'notifications/index'
  get 'static_pages/contact'
  get "/", to: "index#index"
  
  get "/posts/categories/:id", to: "categories#show"
  get "/posts/categories", to: "categories#index"

  get "/posts/create", to: "posts#create"
  post "/posts/create", to: "posts#create"
  get "/posts/delete", to: "posts#delete"
  post "/posts/delete", to: "posts#delete"
  get "/posts/my", to: "posts#my"
  get "/posts/:id", to: "posts#show", as: 'post'
  get "/posts", to: "posts#index"

  post "/messages/create", to: "messages#create"
  post "/messages/update", to: "messages#update"
  post "/messages/delete", to: "messages#delete"
  get "/messages/:id", to: "messages#read", as: 'messages'

  get '/conversations/direct', to: 'conversations#direct'
  post '/conversations/create', to: 'conversations#create'
  post '/conversations/update', to: 'conversations#update'
  post '/conversations/delete', to: 'conversations#delete'
  get '/conversations/:id', to: 'conversations#read', as: 'conversation'
  post '/conversations/:id', to: 'conversations#read'
  get '/conversations', to: 'conversations#index'

  get '/users/me', to: 'users#me'
  get '/users', to: 'users#index', as: 'users'

  post '/friends/new', to: 'friends#new'
  post '/friends/deny', to: 'friends#deny'
  post '/friends/accept', to: 'friends#accept'
  get '/friends/list', to: 'friends#list'
  get '/friends/pending', to: 'friends#pending'
  get '/friends/sent', to: 'friends#sent'
  get '/friends', to: 'friends#index'

  resources :users, only: [:index, :show]
end
