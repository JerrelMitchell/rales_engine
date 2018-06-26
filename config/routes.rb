Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
<<<<<<< HEAD
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/find_all', to: 'merchants/search#index'
      get 'merchants/random', to: 'merchants/random#show'
      resources :merchants
=======
      get 'items/find', to: 'items/search#show'
      get 'items/find_all', to: 'items/search#index'
      get 'items/random', to: 'items/random#show'
      resources :items, only: [:index, :show]
      resources :merchants do
        resources :items, only: [:index]
      end
>>>>>>> a8cea1554875549bba0e191d90d0a1fa01634c9b
    end
  end
end
