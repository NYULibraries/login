##
# Inherits default values for attributes from base class
# and overrides New School Ldap specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class NewSchoolLdap < Base
        def initialize(omniauth_hash)
          @omniauth_hash = omniauth_hash
          @institution_code = "NS"
          @uid = @username = ns_uid
          @nyuidn = extract_value_from_keyed_array(ldap_hash[:pdsexternalsystemid], "sct")
          super(omniauth_hash)
        end

        # Convenience method to extract Net::LDAP::Entry from OmniAuth::AuthHash, accessible as a hash
        def ldap_hash
          @ldap_hash ||= omniauth_hash.extra.raw_info
        end
        private :ldap_hash

        # Map to NetID - Found in LDAP response as "pdsloginid"
        # Get nil value as blank string so this will fail and calling super will not reset the uid to default
        def ns_uid
          @ns_uid ||= ldap_hash[:pdsloginid].first.to_s
        end
        private :ns_uid

        # Find value in array suffixed with #{key}
        #
        # Ex.
        # => extract_value_from_keyed_array(["yadda::mgmt","etc::nyuidn"], "nyuidn") => "etc"
        def extract_value_from_keyed_array(array, key)
          array.find { |val| /(.+)::#{key}/.match(val) }.split("::").first
        end
        private :extract_value_from_keyed_array
      end
    end
  end
end
