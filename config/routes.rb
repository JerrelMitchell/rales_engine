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
      resources :transactions, only: [:index, :show]

      resources :items, only: [:index, :show] do
        get 'merchant', to: 'items/merchants#show'
      end
      resources :merchants do
        resources :items, only: [:index]
      end
    end
  end
end
