##
# Inherits default values for attributes from base class
# and overrides NYU Shibboleth specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class NYUShibboleth < Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
          @institution_code = "NYU"
          @nyuidn = omniauth_hash.extra.raw_info.nyuidn
          @properties = omniauth_hash.info.merge(properties_attributes)
        end

        def extra_attributes(options = {})
          super(options.merge({entitlement: omniauth_hash.extra.raw_info.entitlement}))
        end
      end
    end
  end
end
