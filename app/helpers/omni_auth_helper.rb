module OmniAuthHelper
  include OmniAuthHashHelper

  def require_valid_omniauth_hash
    redirect_to(login_url) unless omniauth_hash?
  end

  def omniauth_hash
    @omniauth_hash ||= request.env["omniauth.auth"]
  end

  def omniauth_hash?
    super && omniauth_hash.provider == params[:action]
  end
end
