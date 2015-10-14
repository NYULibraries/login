##
# Inherits default values for attributes from base class
# and overrides Aleph specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class Aleph < Base
        def initialize(omniauth_hash)
          @omniauth_hash = omniauth_hash
          @nyuidn = omniauth_hash.uid
          @institution_code = aleph_patron.institution_code
          @first_name = aleph_patron.first_name
          @last_name = aleph_patron.last_name
          super(omniauth_hash)
        end

        ##
        # Merge OmniAuth::AuthHash properties with properties pulled from raw_info in response
        def properties_attributes
          super.merge(aleph_patron.attributes)
        end

        ##
        # Use the Aleph::Patron class to build a new structured object from the OmniAuth::AuthHash
        def aleph_patron
          @aleph_patron ||= Login::Aleph::Patron.new do |instance|
            instance.plif_status = omniauth_hash.extra.raw_info.bor_auth.z303.z303_birthplace
            instance.patron_type = omniauth_hash.extra.raw_info.bor_auth.z305.z305_bor_type
            instance.patron_status = omniauth_hash.extra.raw_info.bor_auth.z305.z305_bor_status
            instance.ill_permission = omniauth_hash.extra.raw_info.bor_auth.z305.z305_photo_permission
            instance.ill_library = omniauth_hash.extra.raw_info.bor_auth.z303.z303_ill_library
            instance.bor_name = omniauth_hash.extra.raw_info.bor_auth.z303.z303_name
          end
        end
        private :aleph_patron

      end
    end
  end
end
