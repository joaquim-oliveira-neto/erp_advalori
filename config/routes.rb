Rails.application.routes.draw do
  resources :sellers, only: [:new, :create]
  resources :payers, only: [:new, :create]
  resources :operations, only: [:new, :show]
  resources :invoices, only: [:new, :create]
  devise_for :users
  root to: 'pages#home'
  post '/cnpj_check', to: 'cnpj_checks#fetch_information'

end
