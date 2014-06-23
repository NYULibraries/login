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
      @access_token ||= client.auth_code.get_token(auth_code, :redirect_uri => oauth_app.redirect_uri).token
    end

    def client
      @client ||= OAuth2::Client.new(oauth_app.uid, oauth_app.secret, site: provider_url)
    end

    def oauth_app
      @oauth_app ||= FactoryGirl.create(:oauth_app_no_redirect)
    end

    def provider_url
      visit login_path
      url = URI.parse(current_url)
      @provider_url = "#{url.scheme}://#{url.host}:#{url.port}"
    end

    def login_and_authorize_nyu_shibboleth_user
      # Log user in via NYU Shibboleth
      shibboleth_callback_url
      # Visit the callback to ensure login and user creation
      visit nyu_home_url
      # Make sure this user is authorized for this app
      oauth_app.authorized_tokens.create(resource_owner_id: current_resource_owner.id)
    end

  end
end
