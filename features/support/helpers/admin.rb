module LoginFeatures
  module Admin
    def set_admin_account(provider)
      FactoryGirl.create(
        :admin,
        provider: provider.to_s,
        omniauth_hash_map: Login::OmniAuthHash::Mapper.new(admin_omniauth_hash(provider)),
        username: admin_omniauth_hash(provider).uid
      )
    end

    def set_admin_login_env(provider)
      OmniAuth.config.mock_auth[provider.to_sym] = admin_omniauth_hash(provider)
    end

    def admin_omniauth_hash(provider)
      @admin_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryGirl.create("#{provider}_authhash".to_sym))
    end

    def set_admin_login_env_for_location(location)
      case location
      when /New School LDAP$/
        set_admin_account(:new_school_ldap)
        set_admin_login_env(:new_school_ldap)
      when /NYU Shibboleth$/
        set_admin_account(:nyu_shibboleth)
        set_admin_login_env(:nyu_shibboleth)
      when /Aleph$/
        set_admin_account(:aleph)
        set_admin_login_env(:aleph)
      else
        raise "Unknown location!"
      end
    end

    # def set_invalid_admin_login_env
    #   OmniAuth.config.mock_auth[:new_school_ldap] = :invalid_credentials
    # end
    #
    # def new_school_callback_url
    #   user_omniauth_authorize_path(:provider => "new_school_ldap")
    # end

  end
end
