Rails.application.routes.draw do
  require 'sidekiq/web'

  root 'users#index'
  resources :users
  mount Sidekiq::Web, at: "/sidekiq"
end
