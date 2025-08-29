# config/routes.rb

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|sv/ do
    resources :tasks

    devise_for :users

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"

    get "pages/home"
    root "pages#home"
  end
end