Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/find_all', to: 'merchants/search#index'
      get 'merchants/random', to: 'merchants/random#show'
      get 'items/find', to: 'items/search#show'
      get 'items/find_all', to: 'items/search#index'
      get 'items/random', to: 'items/random#show'
      resources :items, only: [:index, :show]
      resources :merchants do
        resources :items, only: [:index]
      end
    end
  end
end
