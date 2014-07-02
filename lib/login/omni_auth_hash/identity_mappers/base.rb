##
# Base class sets default values for known attributes
# from passed in OmniAuth::AuthHash
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

        # Map provider to function
        def provider
          @omniauth_hash.provider
        end

        # Map info to function
        def info
          @omniauth_hash.info
        end

        # Default uid
        def uid
          @omniauth_hash.uid
        end

        # Default nyuidn
        def nyuidn
          @omniauth_hash.uid
        end

        # Default username
        def username
          @omniauth_hash.uid
        end

        # Default email
        def email
          @omniauth_hash.info.email
        end

        # Map first name out of hash
        def first_name
          @omniauth_hash.info.first_name
        end

        # Map last name out of hash
        def last_name
          @omniauth_hash.info.last_name
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

      end
    end
  end
end
