module LoginFeatures
  module Ldap

    def signin_to_newschool_ldap
      OmniAuth.config.mock_auth[:new_school_ldap] = OmniAuth::AuthHash.new({
        provider: "new_school_ldap",
        uid: "uid=12345,ou=People,o=newschool.edu,o=cp",
        info: {
          first_name: "Jon",
          last_name: "Snow",
          email: "snowj@newschool.edu",
          nickname: "12345",
          location: ", , ,  ",
          uid: "uid=12345,ou=People,o=newschool.edu,o=cp"
        }
      })
    end

    def submit_invalid_credentials_to_newschool_ldap
      OmniAuth.config.mock_auth[:new_school_ldap] = :invalid_credentials
    end

    def newschool_callback_url
      user_omniauth_authorize_path(:provider => "new_school_ldap")
    end

  end
end
