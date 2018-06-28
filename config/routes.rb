Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      namespace :merchants do
        get 'find',     to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random',   to: 'random#show'
        get 'most_items', to: 'most_items#index'
      end
      resources :merchants do
        get 'revenue', to: 'merchants/revenue#show'
        resources :items, only: [:index]
        resources :invoices, only: [:index]
      end

      namespace :items do
        get 'find',         to: 'search#show'
        get 'find_all',     to: 'search#index'
        get 'random',       to: 'random#show'
        get 'most_revenue', to: 'golden#index'
      end
      resources :items, only: [:index, :show] do
        get 'merchant',      to: 'items/merchants#show'
        get 'invoice_items', to: 'items/invoice_items#index'
      end

      namespace :customers do
        get 'find',     to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random',   to: 'random#show'
      end
      resources :customers, only: [:index, :show] do
        get 'invoices',     to: 'customers/invoices#index'
        get 'transactions', to: 'customers/transactions#index'
      end

      namespace :transactions do
        get 'find',     to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random',   to: 'random#show'
      end
      resources :transactions, only: [:index, :show] do
        get 'invoice', to: 'transactions/invoices#show'
      end

      namespace :invoice_items do
        get 'find',     to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random',   to: 'random#show'
      end
      resources :invoice_items, only: [:index, :show] do
        get 'invoice', to: 'invoice_items/invoices#show'
        get 'item',    to: 'invoice_items/items#show'
      end

      namespace :invoices do
        get 'find',     to: 'search#show'
        get 'find_all', to: 'search#index'
        get 'random',   to: 'random#show'
      end
      resources :invoices, only: [:index, :show] do
        get "transactions",  to: 'invoices/transactions#index'
        get "invoice_items", to: 'invoices/invoice_items#index'
        get "items",         to: 'invoices/items#index'
        get "customer",      to: 'invoices/customers#show'
        get "merchant",      to: 'invoices/merchants#show'
      end
    end
  end
end
