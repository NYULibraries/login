module LoginFeatures
  module Doorkeeper

    def current_resource_owner(provider = "nyu_shibboleth")
      @current_resource_owner ||= User.where(username: Login::OmniAuthHash::Mapper.new(eval("#{provider}_omniauth_hash")).username, provider: provider).first
    end

    def authorization_code
      @authorization_code ||= (authorization_code?) ? page.find("#authorization_code").text : "foobar"
    end

    def authorization_code?
      page.has_css?("#authorization_code")
    end

    def client_authorize_url
      @client_authorize_url ||= client.auth_code.authorize_url(:redirect_uri => oauth_app.redirect_uri)
    end

    def access_token
      @access_token ||= client.auth_code.get_token(authorization_code, :redirect_uri => oauth_app.redirect_uri).token
    end

    def client
      @client ||= OAuth2::Client.new(oauth_app.uid, oauth_app.secret, site: provider_url)
    end

    def oauth_app
      @oauth_app ||= FactoryGirl.create(:oauth_app_no_redirect)
    end

    def provider_url
      @provider ||= Capybara.app_host
    end
  end
end
