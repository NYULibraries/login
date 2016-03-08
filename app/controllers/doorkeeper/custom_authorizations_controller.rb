class Doorkeeper::CustomAuthorizationsController < Doorkeeper::AuthorizationsController
  prepend_before_filter :set_institution_from_param, only: [:new]

  private

  def set_institution_from_param
    if params["institution"] || params["umlaut.institution"]
      cookies[:institution_from_url] = params["institution"] || params["umlaut.institution"]
    end
  end

end
