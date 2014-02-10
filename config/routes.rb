Login::Application.routes.draw do
  providers = Regexp.union(Devise.omniauth_providers.map(&:to_s))
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'users' }
  devise_scope :user do
    get 'users/:provider/:id(/:institute)', to: 'users#show', as: 'user', constraints: { provider: providers }
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login(/:institute)', to: 'devise/sessions#new', as: :login
    get 'api/v1/user', to: 'users#api', defaults: { format: :json }
    root 'users#show'
  end
end
