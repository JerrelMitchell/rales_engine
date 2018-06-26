Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/find_all', to: 'merchants/search#index'
      get 'merchants/random', to: 'merchants/random#show'

      get 'items/find', to: 'items/search#show'
      get 'items/find_all', to: 'items/search#index'
      get 'items/random', to: 'items/random#show'

      get 'transactions/find', to: 'transactions/search#show'
      get 'transactions/find_all', to: 'transactions/search#index'
      get 'transactions/random', to: 'transactions/random#show'

      get 'customers/find', to: 'customers/search#show'
      get 'customers/find_all', to: 'customers/search#index'
      get 'customers/random', to: 'customers/random#show'


      resources :transactions, only: [:index, :show]
      resources :customers, only: [:index, :show]

      resources :items, only: [:index, :show] do
        get 'merchant', to: 'items/merchants#show'
        get 'invoice_items', to: 'items/invoice_items#index'
      end
      resources :merchants do
        resources :items, only: [:index]
      end
    end
  end
end
