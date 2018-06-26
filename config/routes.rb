Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
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
