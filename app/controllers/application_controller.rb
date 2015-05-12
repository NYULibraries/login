require 'institutions'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  # Include these helper functions explicitly to make them available to controllers
  include Nyulibraries::Assets::InstitutionsHelper, UsersHelper

  LOGGED_IN_COOKIE_NAME = '_login_sso'

 private

  # After signing out of the logout application,
  # redirect to a "you are logged out, please close your browser" page
  def after_sign_out_path_for(resource_or_scope)
    if current_user.provider == 'nyu_shiboleth'
      ENV['SHIBBOLETH_LOGOUT_URL']
    else
      logged_out_path(current_institution.code.downcase)
    end
  end

  # Create the encrypted value of a logged in user based on
  # shared secret and the user's username
  def loggedin_cookie_value(user)
    AESCrypt.encrypt(user.username, ENV['LOGIN_SHARED_SECRET']).strip
  end

end
