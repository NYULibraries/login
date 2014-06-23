module LoginFeatures
  module ClientApp

    def set_provider_url
      visit login_path
      url = URI.parse(current_url)
      @provider_url = "#{url.scheme}://#{url.host}:#{url.port}"
    end

    def login_and_authorize_nyu_shibboleth_user
      # Log user in via NYU Shibboleth
      login_as_nyu_shibboleth
      # Visit the callback to ensure login and user creation
      visit nyu_home_url
      # Make sure this user is authorized for this app
      oauth_app.authorized_tokens.create(resource_owner_id: current_resource_owner.id)
    end
    
  end
end
