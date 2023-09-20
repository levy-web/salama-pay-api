Rails.application.routes.draw do
  resources :pending_seller_transactions
  resources :accounts
  resources :escrow_accounts
  resources :transactions
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :transactions do
    member do
      post 'confirm_transaction' # Define a custom route for confirming transactions
    end
  end
end
