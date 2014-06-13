require 'institutions'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  # Make these functions available to views
  helper :institutions

  # Include these helper functions explicitly to make them available to controllers
  include InstitutionsHelper, OmniAuthHelper, UsersHelper
end
