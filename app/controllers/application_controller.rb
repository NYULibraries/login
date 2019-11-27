require 'institutions'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_raven_context

  ESHELF_COOKIE_NAME = :_nyulibraries_eshelf_passthru
  REDIRECT_COOKIE_NAME = :_nyulibraries_redirect_uri
  CACHED_REDIRECT_COOKIE_NAME = :_nyulibraries_cached_redirect_uri

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  # Include these helper functions explicitly to make them available to controllers
  include UsersHelper

  def current_user_dev
    current_user = User.find_by_username('admin')
    sign_in(:user, current_user)
    @current_user ||= current_user
  end
  # alias_method :current_user, :current_user_dev if Rails.env.development?

  def require_login!
    unless user_signed_in?
      @redirect_uri = request.fullpath
      render("wayf/index", institution: institution)
    end
  end

  protected

  def after_sign_in_path_for(resource)
    # If there is an eshelf login variable set then we want to redirect there after login
    # to permanently save eshelf records
    if ENV['ESHELF_LOGIN_URL'] && !cookies[ESHELF_COOKIE_NAME]
      session[:_action_before_eshelf_redirect] = (stored_location_for(resource) || request.env['omniauth.origin'] || flash[REDIRECT_COOKIE_NAME])
      create_eshelf_cookie!
      ENV['ESHELF_LOGIN_URL']
    else
      super(resource)
    end
  end

  # After signing out of the logout application,
  # redirect to a "you are logged out, please close your browser" page
  def after_sign_out_path_for(resource_or_scope)
    if cookies[:provider] == 'nyu_shibboleth' && ENV['SHIBBOLETH_LOGOUT_URL']
      ENV['SHIBBOLETH_LOGOUT_URL']
    else
      logged_out_path(cookies[:current_institution])
    end
  end

  private

  def create_eshelf_cookie!
    cookie_hash = { value: 1, httponly: true, domain: ENV['LOGIN_COOKIE_DOMAIN'] }
    cookies[ESHELF_COOKIE_NAME] = cookie_hash
  end

  def set_raven_context
    Raven.user_context(id: current_user&.id, username: current_user&.username, email: current_user&.email, ip_address: request.ip)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
