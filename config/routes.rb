# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  get '/index', to: 'home#index'
  get '/leaderboards', to: 'home#leaderboards'
  devise_for :overseers
  # devise_for :users
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords', omniauth_callbacks: "users/omniauth_callbacks"}, path: 'users'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      resources :swish do
        collection do
          get 'generate'
        end
      end
    end
  end

  namespace :users do
    resources :swish
  end
end
