Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'users#index'
  resources :users
  get 'update_users', to: 'users#update_users'
  mount Sidekiq::Web, at: "/sidekiq"
end
