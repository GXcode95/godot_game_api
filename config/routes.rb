Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      devise_for :users,
                 path: 'auth',
                 defaults: { format: :json },
                 controllers: {
                   registrations: 'api/v1/registrations',
                   sessions: 'api/v1/sessions'
                 }

      # Alias pratiques
      devise_scope :user do
        post   'auth',          to: 'registrations#create'      # sign up
        post   'auth/sign_in',  to: 'sessions#create'           # sign in
        delete 'auth/sign_out', to: 'sessions#destroy'          # sign out
        delete 'auth',          to: 'registrations#destroy'     # delete account
      end
    end
  end
end
