##
# Inherits default values for attributes from base class
# and overrides New School Ldap specific ones
module Login
  module OmniAuthHash
    module IdentityMappers
      class NewSchoolLdap < Login::OmniAuthHash::IdentityMappers::Base

        def initialize(omniauth_hash)
          super(omniauth_hash)
        end

        # Map to NetID
        # Found in LDAP response as "pdsloginid"
        def uid
          ldap_hash[:pdsloginid].first
        end

        # Map to email
        def username
          @omniauth_hash.info.email
        end

        # Map to N Number
        # Found in LDAP response as a value under "pdsexternalsystemid" array with a "::sct" suffix
        def nyuidn
          extract_value_from_keyed_array(ldap_hash[:pdsexternalsystemid], "sct")
        end

        # Convenience method to extract Net::LDAP::Entry from OmniAuth::AuthHash
        def ldap_hash
          @omniauth_hash.extra.raw_info
        end

        # Find value in array suffixed with #{key}
        def extract_value_from_keyed_array(array, key)
          array.find { |val| /(.+)::#{key}/.match(val) }.split("::").first
        end
        private :extract_value_from_keyed_array

      end
    end
  end
end
