##
# Inherits default values for attributes from base class
# and overrides Aleph specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class Aleph < Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
          @nyuidn = omniauth_hash.uid
        end

        ##
        # Override hash of extra attributes for merging into properties
        def properties_attributes
          super.merge({
              extra: {
                plif_status: @omniauth_hash.extra.raw_info.bor_auth.z303.z303_birthplace,
                patron_type: @omniauth_hash.extra.raw_info.bor_auth.z305.z305_bor_type,
                patron_status: @omniauth_hash.extra.raw_info.bor_auth.z305.z305_bor_status,
                ill_permission: @omniauth_hash.extra.raw_info.bor_auth.z305.z305_photo_permission
              }.merge(@omniauth_hash.extra)
            })
        end
      end
    end
  end
end
