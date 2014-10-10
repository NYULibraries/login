Login::Application.routes.draw do
  providers = Regexp.union(Devise.omniauth_providers.map(&:to_s))
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'users' }
  devise_scope :user do
    get 'users/:provider/:id(/:institute)', to: 'users#show', as: 'user',
      constraints: { provider: providers, id: /[^\/]+/ }
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'auth/:auth_type(/:institute)', to: 'devise/sessions#new', as: :auth
    root 'users#show'
  end
  get 'login(/:institute)', to: 'wayf#index', as: :login
  namespace :api do
    namespace :v1 do
      get '/user' => "users#show", defaults: { format: :json }
    end
  end
end
