Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find',     to: 'merchants/search#show'
      get 'merchants/find_all', to: 'merchants/search#index'
      get 'merchants/random',   to: 'merchants/random#show'
      resources :merchants do
        resources :items, only: [:index]
      end

      get 'items/find',     to: 'items/search#show'
      get 'items/find_all', to: 'items/search#index'
      get 'items/random',   to: 'items/random#show'
      resources :items, only: [:index, :show] do
        get 'merchant',      to: 'items/merchants#show'
        get 'invoice_items', to: 'items/invoice_items#index'
      end

      get 'customers/find',     to: 'customers/search#show'
      get 'customers/find_all', to: 'customers/search#index'
      get 'customers/random',   to: 'customers/random#show'
      resources :customers, only: [:index, :show] do
        get 'invoices',     to: 'customers/invoices#index'
        get 'transactions', to: 'customers/transactions#index'
      end

      get 'transactions/find',     to: 'transactions/search#show'
      get 'transactions/find_all', to: 'transactions/search#index'
      get 'transactions/random',   to: 'transactions/random#show'
      resources :transactions, only: [:index, :show]

      get 'invoice_items/find',     to: 'invoice_items/search#show'
      get 'invoice_items/find_all', to: 'invoice_items/search#index'
      get 'invoice_items/random',   to: 'invoice_items/random#show'
      resources :invoice_items, only: [:index, :show] do
        get 'invoice', to: 'invoice_items/invoice#show'


      end

      get 'invoices/find',     to: 'invoices/search#show'
      get 'invoices/find_all', to: 'invoices/search#index'
      get 'invoices/random',   to: 'invoices/random#show'
      resources :invoices, only: [:index, :show]
    end
  end
end
