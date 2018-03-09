module LoginFeatures
  module Twitter

    def set_twitter_login_env
      OmniAuth.config.mock_auth[:twitter] = twitter_omniauth_hash
    end

    def twitter_omniauth_hash
      @twitter_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryBot.create(:twitter_authhash))
    end

    def set_invalid_aleph_login_env
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    end

    def twitter_url
      user_twitter_omniauth_authorize_path
    end

  end
end
