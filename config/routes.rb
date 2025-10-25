# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      devise_for :users,
                 path: 'auth',
                 defaults: { format: :json },
                 controllers: {
                   registrations: 'api/v1/registrations',
                   sessions: 'api/v1/sessions'
                 }

      devise_scope :user do
        post   'auth',          to: 'registrations#create'
        post   'auth/sign_in',  to: 'sessions#create'
        delete 'auth/sign_out', to: 'sessions#destroy'
        delete 'auth',          to: 'registrations#destroy'
      end

      resources :lobbies, only: [:index, :show, :create, :update, :destroy]
    end
  end

  mount ActionCable.server => '/cable'
end
