require 'institutions'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  # Include these helper functions explicitly to make them available to controllers
  include InstitutionsHelper, UsersHelper

  private

  # After signing out of the logout application,
  # kill SSO sessions and redirect to terminal page
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
