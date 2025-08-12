Rails.application.routes.draw do
  resources :blogs do
    resources :comments, only: [ :create, :destroy, :update ]
  end

  resources :users

  resources :comments

  get "/csrf-token", to: "csrf_token#show"

  root "blogs#index"

  post "/destroy", to: "blogs#destroy"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  post "/logout", to: "sessions#destroy"

  get "/register", to: "users#new"
  post "/register", to: "users#create"
end
