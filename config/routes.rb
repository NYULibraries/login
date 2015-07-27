Login::Application.routes.draw do
  providers = Regexp.union(Devise.omniauth_providers.map(&:to_s))
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'users', sessions: 'users/sessions' }
  devise_scope :user do
    get 'users/:provider/:id(/:institution)', to: 'users#show', as: 'user',
      constraints: { provider: providers, id: /[^\/]+/ }
    get 'logout(/:institution)', to: 'users/sessions#destroy', as: :logout
    get 'auth/:auth_type(/:institution)', to: 'devise/sessions#new', as: :auth
    get 'login/passive', to: 'users#check_passive_and_sign_client_in'
    get 'users/show', to: 'users#show'
    post 'passthru', to: 'users#passthru'
    root 'users#show'
  end
  get 'login(/:institution)', to: 'wayf#index', as: :login
  get 'logged_out(/:institution)', to: 'wayf#logged_out', as: :logged_out
  namespace :api do
    namespace :v1 do
      get '/user' => "users#show", defaults: { format: :json }
    end
  end
end
