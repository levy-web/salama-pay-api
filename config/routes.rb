Rails.application.routes.draw do
  get 'contract_infos/index'
  get 'contract_infos/show'
  get 'contract_infos/new'
  get 'contract_infos/create'
  get 'contract_infos/edit'
  get 'contract_infos/update'
  get 'contract_infos/destroy'

  # Define a route for GET request to "/contract_infos/:id"
  get '/contract_infos/:id', to: 'contract_infos#show'

  # Define a route for PUT request to "/contract_infos/:id"
  put '/contract_infos/:id', to: 'contract_infos#update'

  resources :emails, only: [:new, :create]
  resources :mpesas
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
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
      post "confirm_transaction" # Define a custom route for confirming transactions
    end
  end

  resources :transactions do
    member do
      put "complete", to: "transactions#complete_transaction"
    end
  end

  post "/login", to: "sessions#user_create"

  resources :users do
    member do
      post "verify_code"
    end
  end
  post "/stkpush", to: "mpesas#stkpush"
  post "/stkquery", to: "mpesas#stkquery"
  post "/send-email", to: "emails#send_email"
end
