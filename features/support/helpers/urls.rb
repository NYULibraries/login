module LoginFeatures
  module Urls
    def nyu_home_url(institute = "NYU")
      user_omniauth_authorize_path({provider: "nyu_shibboleth"}.merge(institute_user(institute)))
    end

    private

    def institute_user(institute)
      meth = "dummy_#{institute.downcase}_user"
      send(meth.to_sym) if defined?(meth.to_sym) == "method"
    end

    def dummy_nyu_user
      dummy_user.merge({
        institute: "NYU",
        uid: username_for_location("NYU New York")
      })
    end

    def dummy_nyush_user
      dummy_user.merge({
        institute: "NYUSH",
        uid: username_for_location("NYU Shanghai")
      })
    end

    def dummy_nyuad_user
      dummy_user.merge({
        institute: "NYUAD",
        uid: username_for_location("NYU Abu Dhabi")
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
        nyuidn: "N12345678"
      }
    end
  end
end
