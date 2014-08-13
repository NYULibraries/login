##
# Inherits default values for attributes from base class
# and overrides Facebook specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class Facebook < Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
          # Map to nickname if exists, or to email
          @username = (omniauth_hash.info.nickname || omniauth_hash.info.email)
        end
      end
    end
  end
end
