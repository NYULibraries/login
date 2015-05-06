require 'institutions'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout Proc.new { |controller| (controller.request.xhr?) ? false : "login" }

  # Include these helper functions explicitly to make them available to controllers
  include InstitutionsHelper, UsersHelper

  def whitelisted_client_applications
    @whitelisted_client_applications ||= Doorkeeper::Application.all.collect do |app|
      URI.parse(app.redirect_uri).host
    end
  end
end
