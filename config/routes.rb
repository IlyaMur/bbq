Rails.application.routes.draw do
  devise_for :users
  resources :users
  root "events#index"
  
  resources :users, only: [:show, :update, :edit]
  resources :events
end
