Rails.application.routes.draw do
  resources :sellers, only: [:new, :create]
  resources :payers, only: [:new, :create]
  resources :operations, only: [:new, :show]
  resources :invoices, only: :new
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
