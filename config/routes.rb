Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants/search#show'
      resources :merchants
    end
  end
end
