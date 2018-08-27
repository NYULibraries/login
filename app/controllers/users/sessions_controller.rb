class Users::SessionsController < Devise::SessionsController
  before_action :save_user_info, only: :destroy
  after_action :sso_logout, only: :destroy

  private

  # Single sign out by clearing cookies on all sub domains
  def sso_logout
    # Logout of Bobcat first while we still have the PDS_HANDLE cookie
    bobcat_logout.logout!
    # Then clear all library.nyu.edu cookies
    cookies.clear(domain: ENV['LOGIN_COOKIE_DOMAIN'])
    # If a user logs into client application and then logs out of that application
    # and then tries to login to another SSO client application, passive shibboleth
    # will be called and log them in automatically, this stops that
    session[:_check_passive_shibboleth] = true
  end

  def bobcat_logout
    @bobcat_logout ||= Login::Primo::Logout.new(bobcat_url, cookies['PDS_HANDLE'])
  end

  # Save use info in cookies before logging out so we can use them
  # to direct to the proper logout page
  def save_user_info
    if current_user
      cookies[:provider] = current_user.provider
      cookies[:current_institution] = current_institution.code.downcase
    end
  end

  def bobcat_url
    @bobcat_url ||= ENV['BOBCAT_URL'] || 'http://bobcatdev.library.nyu.edu'
  end

end
