##
# Inherits default values for attributes from base class
# and overrides NYU Shibboleth specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class NYUShibboleth < Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
          @nyuidn = omniauth_hash.extra.raw_info.nyuidn
          @properties = omniauth_hash.info.merge(extra_attributes)
        end

        def extra_attributes
          super().merge({
            extra: super()[:extra].merge({
              entitlement: omniauth_hash.extra.raw_info.entitlement
            })
          })
        end
      end
    end
  end
end
