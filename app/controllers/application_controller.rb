require 'institutions'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  PASSIVE_SHIBBOLETH_URL_STRING = "/Shibboleth.sso/Login?isPassive=true&target="
  SHIBBOLETH_COOKIE_PATTERN = "_shibsession_"
  LOGGED_IN_COOKIE_NAME = '_nyulibraries_logged_in'
  ESHELF_COOKIE_NAME = '_nyulibraries_eshelf_passthru'

  # Include these helper functions explicitly to make them available to controllers
  include Nyulibraries::Assets::InstitutionsHelper, UsersHelper

  # After signing out of the logout application,
  # redirect to a "you are logged out, please close your browser" page
  def after_sign_out_path_for(resource_or_scope)
    if cookies[:provider] == 'nyu_shibboleth' && ENV['SHIBBOLETH_LOGOUT_URL']
      return ENV['SHIBBOLETH_LOGOUT_URL']
    else
      return logged_out_path(cookies[:current_institution])
    end
  end

end
