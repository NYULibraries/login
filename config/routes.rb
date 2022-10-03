EZBORROW_URL = (ENV['EZBORROW_URL'] || "https://library.nyu.edu/services/borrowing/from-non-nyu-libraries/e-zborrow/").freeze

Rails.application.routes.draw do
  providers = Regexp.union(Devise.omniauth_providers.map(&:to_s))
  use_doorkeeper do
    controllers :authorizations => 'doorkeeper/custom_authorizations'
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions' }
  devise_scope :user do
    root to: 'wayf#index', as: 'root'
    get 'users/:provider/:id(/:institution)', to: 'users#show', as: 'user',
      constraints: { provider: providers, id: /[^\/]+/ }
    get 'logout(/:institution)', to: 'users/sessions#destroy', as: :logout
    get 'auth/:auth_type(/:institution)', to: 'users/sessions#new', as: :auth
    get 'login/passive', to: 'users/client_passive_login#client_passive_login'
    get 'login/passive_shibboleth', to: 'users/client_passive_login#shibboleth_passive_login', as: :passive_shibboleth
    get 'users/show', to: 'users#show'
    match 'passthru', to: 'users/passthru#passthru', via: [:post, :get], as: :passthru
  end
  get 'login(/:institution)', to: 'wayf#index', as: :login
  get 'logged_out(/:institution)', to: 'wayf#logged_out', as: :logged_out
  namespace :api do
    namespace :v1 do
      get '/user' => "users#show", defaults: { format: :json }
    end
  end
  get 'pds' => redirect { |params, request| "#{ENV['PDS_URL']}/pds?#{request.query_string}" }
  get '/ezborrow(/:institution)' => redirect { EZBORROW_URL }
  get 'ezproxy' => redirect { |params, request| "#{ENV['EZPROXY_URL']}/login?#{request.query_string}" }
  get 'healthcheck' => 'root#healthcheck'
end
