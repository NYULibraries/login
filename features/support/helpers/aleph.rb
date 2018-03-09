module LoginFeatures
  module Aleph

    def set_aleph_login_env
      OmniAuth.config.mock_auth[:aleph] = aleph_omniauth_hash
    end

    def aleph_omniauth_hash
      @new_school_ldap_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryBot.create(:aleph_authhash))
    end

    def set_invalid_aleph_login_env
      OmniAuth.config.mock_auth[:aleph] = :invalid_credentials
    end

    def aleph_url
      user_aleph_omniauth_authorize_path
    end

  end
end
