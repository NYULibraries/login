module LoginFeatures
  module Doorkeeper

    def current_resource_owner
      @current_resource_owner ||= User.where(username: shibboleth_hash[:uid], provider: shibboleth_hash[:provider]).first
    end

    def auth_code
      @auth_code ||= page.find("#authorization_code").text
    end

    def auth_url
      @auth_url ||= client.auth_code.authorize_url(:redirect_uri => oauth_app.redirect_uri)
    end

    def access_token
      @access_token ||= client.auth_code.get_token(auth_code, :redirect_uri => oauth_app.redirect_uri).token
    end

    def client
      @client ||= OAuth2::Client.new(oauth_app.uid, oauth_app.secret, site: @site) unless @site.blank?
    end

    def oauth_app
      @oauth_app ||= FactoryGirl.create(:oauth_app_no_redirect)
    end

  end
end
