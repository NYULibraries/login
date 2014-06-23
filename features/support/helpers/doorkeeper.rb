module LoginFeatures
  module Doorkeeper

    def current_resource_owner
      @current_resource_owner ||= User.where(username: shibboleth_hash[:uid], provider: shibboleth_hash[:provider]).first
    end

    def auth_code
      @auth_code ||= page.find("#authorization_code").text
    end

    def client_authorize_url
      @client_authorize_url ||= client.auth_code.authorize_url(:redirect_uri => oauth_app.redirect_uri)
    end

    def access_token
      @access_token ||= oauth_app.authorized_tokens.where(resource_owner_id: current_resource_owner.id).first.token
    end

    def client
      @client ||= OAuth2::Client.new(oauth_app.uid, oauth_app.secret, site: @provider_url) unless @provider_url.blank?
    end

    def oauth_app
      @oauth_app ||= FactoryGirl.create(:oauth_app_no_redirect)
    end

  end
end
