module LoginFeatures
  module NYUShibboleth
    def nyu_shibboleth_callback_url(institute = "NYU")
      user_omniauth_authorize_path({provider: "nyu_shibboleth"}.merge(institute_user(institute)))
    end

    def set_nyu_shibboleth_login_env
      OmniAuth.config.mock_auth[:nyu_shibboleth] = nyu_shibboleth_omniauth_hash
    end

    def nyu_shibboleth_omniauth_hash
      @nyu_shibboleth_omniauth_hash ||= OmniAuth::AuthHash.new(FactoryGirl.create(:nyu_shibboleth_authhash))
    end

    private

    def nyu_shibboleth_username_for_institute(institute)
      case institute
      when /NYU New York/
        :dev123
      when /NYU Abu Dhabi/
        :addev123
      when /NYU Shanghai/
        :shdev123
      else
        raise "Unknown Shibboleth institute!"
      end
    end

    def institute_user(institute)
      meth = "dummy_#{institute.downcase}_user"
      send(meth.to_sym) if defined?(meth.to_sym) == "method"
    end

    def dummy_nyu_user
      dummy_user.merge({
        institute: "NYU",
        uid: nyu_shibboleth_username_for_institute("NYU New York")
      })
    end

    def dummy_nyush_user
      dummy_user.merge({
        institute: "NYUSH",
        uid: nyu_shibboleth_username_for_institute("NYU Shanghai")
      })
    end

    def dummy_nyuad_user
      dummy_user.merge({
        institute: "NYUAD",
        uid: nyu_shibboleth_username_for_institute("NYU Abu Dhabi")
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
        nyuidn: ENV['ALEPH_TEST_USER'] || 'BOR_ID'
      }
    end
  end
end
