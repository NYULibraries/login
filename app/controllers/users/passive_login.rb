module Users::PassiveLogin
  include WhitelistedApplications

  private

  PASSIVE_SHIBBOLETH_URL_STRING = "/Shibboleth.sso/Login?isPassive=true&target="
  SHIBBOLETH_COOKIE_PATTERN = "_shibsession_"
  def passive_shibboleth_url
    "#{PASSIVE_SHIBBOLETH_URL_STRING}#{uri_component_original_url}"
  end

  def shib_session_exists?
    !cookies.detect {|key| key.include? SHIBBOLETH_COOKIE_PATTERN }.nil?
  end

  def uri_component_original_url
    CGI::escape(request.original_url)
  end

  def nyu_shibboleth_omniauth_authorize_path
    user_omniauth_authorize_path(:nyu_shibboleth,
                                 institute: current_institute.code,
                                 auth_type: :nyu,
                                 redirect_to: uri_component_original_url)
  end
end
