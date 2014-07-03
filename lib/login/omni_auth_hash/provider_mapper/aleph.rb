##
# Inherits default values for attributes from base class
# and overrides Aleph specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class Aleph < Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
          @properties = @omniauth_hash.info.merge(extra_attributes)
        end
      end
    end
  end
end
