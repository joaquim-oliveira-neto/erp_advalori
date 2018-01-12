Rails.application.routes.draw do
  resources :sellers, only: [:new, :create]
  resources :payers, only: [:new, :create]
  resources :operations, only: [:new, :show]
  resources :invoices, only: [:new, :create]
  post '/invoices/load_xml', to: 'invoices#load_invoice_from_xml'

  devise_for :users
  root to: 'pages#home'
  post '/cnpj_check', to: 'cnpj_checks#fetch_information'

end
