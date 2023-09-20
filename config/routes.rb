Rails.application.routes.draw do
  resources :pending_seller_transactions
  resources :accounts
  resources :escrow_accounts
  resources :transactions
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
