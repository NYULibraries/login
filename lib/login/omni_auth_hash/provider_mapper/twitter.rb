##
# Inherits default values for attributes from base class
# and overrides Twitter specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class Twitter < Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
          # Map username to nickname
          @username = omniauth_hash.info.nickname
          @properties = @omniauth_hash.info.merge(extra_attributes)
        end
      end
    end
  end
end
