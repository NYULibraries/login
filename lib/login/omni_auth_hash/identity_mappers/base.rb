##
#
module Login
  module OmniAuthHash
    module IdentityMappers
      class Base

        def initialize(omniauth_hash)
          @omniauth_hash = omniauth_hash
        end

        ##
        # Return OmniAuth::AuthHash representation
        def to_hash
          @omniauth_hash
        end

        def uid
          @omniauth_hash.uid
        end

        def nyuidn
          @omniauth_hash.uid
        end

        def username
          @omniauth_hash.uid
        end

        def provider
          @omniauth_hash.provider
        end

        def info
          @omniauth_hash.info
        end

        def email
          @omniauth_hash.info.email
        end

        ##
        # Generate the properties hash from InfoHash and extra fields
        def properties
          @omniauth_hash.info.merge(extra_attributes)
        end

        ##
        # Define hash of extra attributes for merging into properties
        def extra_attributes
          {
            extra: @omniauth_hash.extra,
            uid: self.uid,
            first_name: first_name,
            last_name: last_name,
            nyuidn: nyuidn
          }
        end

        ##
        # Get first name out of hash
        def first_name
          @omniauth_hash.info.first_name
        end

        ##
        # Get last name out of hash
        def last_name
          @omniauth_hash.info.last_name
        end

        ##
        # Check if method_id matches the is_role? schema
        def matches_attribute_name?(method_id)
          whitelist_attributes.include? method_id.to_sym
        end
        private :matches_attribute_name?

        def whitelist_attributes
          [:uid, :username, :first_name, :last_name, :nyuidn]
        end

      end
    end
  end
end
