module LoginFeatures
  module Facebook

    def set_facebook_login_env
      OmniAuth.config.mock_auth[:facebook] = facebook_omniauth_hash
    end

    def facebook_omniauth_hash
      @facebook_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryGirl.create(:facebook_authhash))
    end

    def set_invalid_aleph_login_env
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    end

    def facebook_url
      user_facebook_omniauth_authorize_path
    end

  end
end
