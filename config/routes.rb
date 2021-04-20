Rails.application.routes.draw do
  resources :users
  root "events#index"
  
  resources :users, only: [:show, :update, :edit]
  resources :events
end
