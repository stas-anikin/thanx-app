Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :index, :show, :create ] do
        member do
          get :points_balance
          get :redemptions
          patch :add_points
        end
      end

      resources :rewards, only: [ :index, :show ]

      resources :redemptions, only: [ :create, :show ] do
        member do
          patch :cancel
        end
      end
    end
  end
end
