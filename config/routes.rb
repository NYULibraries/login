Login::Application.routes.draw do
  VALID_PROVIDERS = Devise.omniauth_providers.map(&:to_s)
  providers = Regexp.union(VALID_PROVIDERS)
  # use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'users' }
  devise_scope :user do
    get 'users/:provider/:id(/:institute)', to: 'users#show', as: 'user', constraints: { provider: providers }
    get 'logout', to: 'devise/sessions#destroy', as: :logout
    get 'login(/:institute)', to: 'devise/sessions#new', as: :login
    root 'users#show'
  end
end
