# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  devise_for :overseers
 # devise_for :users
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions', passwords: 'users/passwords'}, path: 'users'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  namespace :users do
    resources :swish
  end
end
