Rails.application.routes.draw do
  resources :subscriptions
  resources :comments
  devise_for :users
  resources :users
  root 'events#index'
  
  resources :users, only: %i[show update edit]

  resources :events do
    resources :comments, only: %i[create destroy]
    resources :subscriptions, only: %i[create destroy]
  end
end
