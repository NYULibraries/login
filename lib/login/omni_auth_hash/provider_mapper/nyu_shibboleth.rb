##
# Inherits default values for attributes from base class
# and overrides NYU Shibboleth specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class NYUShibboleth < Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
          @nyuidn = @omniauth_hash.extra.nyuidn
        end
      end
    end
  end
end
