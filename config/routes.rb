Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchant_search#show'
      get 'items/find_all', to: 'items_search#index'
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], to: 'merchant_items#index'
      end
  
      resources :items do
        resources :merchant, to: 'merchant_items#show'
      end
    end
  end
end
