class SessionsController < Devise::SessionsController
  before_filter :destroy_sso_cookie!, only: :destroy, if: -> { cookies[LOGGED_IN_COOKIE_NAME].present? }

 private

  # When destroying local session, destroy cookie that tells
  # calling applications we're logged in
  def destroy_sso_cookie!
    if ENV['COOKIE_DOMAIN']
      cookies.delete(LOGGED_IN_COOKIE_NAME, domain: ENV['COOKIE_DOMAIN'])
    else
      cookies.delete LOGGED_IN_COOKIE_NAME
    end
  end

end
