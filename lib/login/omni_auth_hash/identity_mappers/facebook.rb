##
# Inherits default values for attributes from base class
# and overrides Facebook specific ones
module Login
  module OmniAuthHash
    module IdentityMappers
      class Facebook < Login::OmniAuthHash::IdentityMappers::Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
        end
        # Map to nickname if exists, or to email
        def username
          @omniauth_hash.info.nickname || @omniauth_hash.info.email
        end
      end
    end
  end
end
