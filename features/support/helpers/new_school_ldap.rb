module LoginFeatures
  module NewSchoolLdap

    def set_new_school_ldap_login_env
      OmniAuth.config.mock_auth[:new_school_ldap] = new_school_ldap_omniauth_hash
    end

    def new_school_ldap_omniauth_hash
      @new_school_ldap_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryGirl.create(:new_school_ldap_authhash))
    end

    def set_invalid_new_school_ldap_login_env
      OmniAuth.config.mock_auth[:new_school_ldap] = :invalid_credentials
    end

    def new_school_callback_url
      user_new_school_ldap_omniauth_authorize_path(auth_type: 'ns')
    end

  end
end
