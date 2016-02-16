module LoginFeatures
  module Admin
    def set_admin_login_env
      set_admin_account
      OmniAuth.config.mock_auth[admin_provider.to_sym] = admin_omniauth_hash
    end

    def omniauth_hash_map
      @omniauth_hash_map ||= Login::OmniAuthHash::Mapper.new(admin_omniauth_hash)
    end

    def admin_omniauth_hash
      @admin_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryGirl.create("#{admin_provider}_authhash".to_sym))
    end

    def login_as_admin
      follow_login_steps_for_location provider_to_location[admin_provider]
    end

    def set_admin_account
      FactoryGirl.create(:admin, omniauth_hash_map: omniauth_hash_map, username: omniauth_hash_map.username)
    end
    private :set_admin_account

    def admin_provider
      @admin_provider ||= FactoryGirl.attributes_for(:admin)[:provider]
    end
  end
end
