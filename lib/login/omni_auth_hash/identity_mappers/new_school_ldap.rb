##
#
module Login
  module OmniAuthHash
    module IdentityMappers
      class NewSchoolLdap < Login::OmniAuthHash::IdentityMappers::Base

        def initialize(omniauth_hash)
          super(omniauth_hash)
        end

        def uid
          ldap_hash[:pdsloginid].first
        end

        def username
          @omniauth_hash.info.email
        end

        def nyuidn
          extract_value_from_keyed_array(ldap_hash[:pdsexternalsystemid], "sct")
        end

        def extract_value_from_keyed_array(array, key)
          array.find { |val| /(.+)::#{key}/.match(val) }.split("::").first
        end
        private :extract_value_from_keyed_array

        def ldap_hash
          @omniauth_hash.extra.raw_info
        end
        private :ldap_hash

      end
    end
  end
end
