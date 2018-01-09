Rails.application.routes.draw do
  get 'invoices/new'

  get 'operations/new'

  get 'operations/show'

  resources :sellers, only: :new
  resources :payers, only: :new
  resources :operations, only: [:new, :show]
  resources :invoices, only: :new


  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
