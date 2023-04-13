# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  namespace :admins do
    resources :transactions, only: :index
    resources :merchants, only: %i[index edit update destroy]
  end

  namespace :merchants do
    resources :transactions, only: :index
  end

  post 'api/auth/login', to: 'api/v1/authentication#login'

  namespace :api do
    namespace :v1 do
      resources :transactions, only: :create do
        collection do
          post :refund
        end
      end
    end
  end
end
