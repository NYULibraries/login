##
# Inherits default values for attributes from base class
# and overrides New School Ldap specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class NewSchoolLdap < Base

        def initialize(omniauth_hash)
          super(omniauth_hash)
          @institution_code = "NS"
          # Map to NetID - Found in LDAP response as "pdsloginid"
          @uid = ldap_hash[:pdsloginid].first
          @username = ldap_hash[:pdsloginid].first
          # Map to N Number - Found in LDAP response as a value under "pdsexternalsystemid" array with a "::sct" suffix
          @nyuidn = extract_value_from_keyed_array(ldap_hash[:pdsexternalsystemid], "sct")
          @properties = omniauth_hash.info.merge(properties_attributes)
        end

        # Convenience method to extract Net::LDAP::Entry from OmniAuth::AuthHash, accessible as a hash
        def ldap_hash
          @ldap_hash ||= omniauth_hash.extra.raw_info
        end
        private :ldap_hash

        # Find value in array suffixed with #{key}
        def extract_value_from_keyed_array(array, key)
          array.find { |val| /(.+)::#{key}/.match(val) }.split("::").first
        end
        private :extract_value_from_keyed_array

      end
    end
  end
end
