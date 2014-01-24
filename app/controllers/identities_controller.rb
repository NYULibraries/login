class IdentitiesController < Devise::OmniauthCallbacksController
  def all
    raise request.env["omniauth.auth"].to_yaml
  end
  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :aleph, :all

  def after_omniauth_failure_path_for(scope)
    login_path(current_institution.code.downcase)
  end
end