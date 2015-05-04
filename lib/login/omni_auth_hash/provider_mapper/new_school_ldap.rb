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
          @nyuidn = nyuidn_from_hash
          super(omniauth_hash)
        end

        # Convenience method to extract Net::LDAP::Entry from OmniAuth::AuthHash, accessible as a hash
        def ldap_hash
          @ldap_hash ||= omniauth_hash.extra.raw_info
        end
        private :ldap_hash

        def nyuidn_from_hash
          @nyuidn_from_hash ||= (ldap_hash[:cn].is_a? Array) ? ldap_hash[:cn].first : ldap_hash[:cn]
        end

      end
    end
  end
end
