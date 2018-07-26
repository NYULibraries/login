class Doorkeeper::CustomAuthorizationsController < Doorkeeper::AuthorizationsController
  prepend_before_action :set_institution_from_param, only: [:new], if: -> { params["institution"].present? }

  private

  def set_institution_from_param
    cookies[:institution_from_url] = params["institution"]
  end

end
