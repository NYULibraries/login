require 'institutions'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  # Include these helper functions explicitly to make them available to controllers
  include InstitutionsHelper, UsersHelper

  rescue_from Login::OmniAuthHash::Validator::ArgumentError do |exception|
    flash[:error] ||= exception.message
    redirect_to login_path(current_institution.code.downcase)
  end
end
