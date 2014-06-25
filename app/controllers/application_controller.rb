require 'institutions'
require 'omni_auth_hash_manager/mapper'
require 'omni_auth_hash_manager/validator'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  # Include these helper functions explicitly to make them available to controllers
  include InstitutionsHelper, UsersHelper

  rescue_from Login::OmniAuthHashManager::Validator::ArgumentError do |exception|
    flash[:error] ||= exception.message.html_safe
    # binding.pry
    redirect_to login_path(current_institution.code.downcase)
  end
end
