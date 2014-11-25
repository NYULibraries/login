##
# Inherits default values for attributes from base class
# and overrides NYU Shibboleth specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class NYUShibboleth < Base
        def initialize(omniauth_hash)
          @omniauth_hash = omniauth_hash
          @institution_code = "NYU"
          @nyuidn = omniauth_hash.extra.raw_info.nyuidn
          super(omniauth_hash)
        end

        def properties_attributes
          super.merge({entitlement: omniauth_hash.extra.raw_info.entitlement})
        end
      end
    end
  end
end
