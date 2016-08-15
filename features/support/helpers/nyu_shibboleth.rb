module LoginFeatures
  module NYUShibboleth
    def nyu_shibboleth_callback_url(institution = "NYU")
      user_nyu_shibboleth_omniauth_authorize_path(institution_user(institution))
    end

    def set_nyu_shibboleth_login_env
      OmniAuth.config.mock_auth[:nyu_shibboleth] = nyu_shibboleth_omniauth_hash
    end

    def nyu_shibboleth_omniauth_hash
      @nyu_shibboleth_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryGirl.create(:nyu_shibboleth_authhash))
    end

  private

    def nyu_shibboleth_username_for_institution(institution)
      case institution
      when /NYU New York/
        :dev123
      when /NYU Abu Dhabi/
        :addev123
      when /NYU Shanghai/
        :shdev123
      else
        raise "Unknown Shibboleth institution!"
      end
    end

    def institution_user(institution)
      meth = "dummy_#{institution.downcase.gsub(/ /,'_')}_user"
      send(meth.to_sym) if defined?(meth.to_sym) == "method"
    end

    def dummy_nyu_user
      dummy_user.merge({
        institution: "NYU",
        uid: nyu_shibboleth_username_for_institution("NYU New York")
      })
    end

    def dummy_nyu_shanghai_user
      dummy_user.merge({
        institution: "NYUSH",
        uid: nyu_shibboleth_username_for_institution("NYU Shanghai")
      })
    end

    def dummy_nyu_abu_dhabi_user
      dummy_user.merge({
        institution: "NYUAD",
        uid: nyu_shibboleth_username_for_institution("NYU Abu Dhabi")
      })
    end

    def dummy_user
      {
        "Shib-Session-ID" => "123",
        "Shib-Application-ID" => "123",
        email: "dev123@example.com",
        givenName: "Dev",
        firstName: "Dev",
        sn: "Eloper",
        nyuidn: ENV['TEST_ALEPH_USER'] || 'BOR_ID'
      }
    end
  end
end
