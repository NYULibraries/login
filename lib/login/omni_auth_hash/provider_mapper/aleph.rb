##
# Inherits default values for attributes from base class
# and overrides Aleph specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class Aleph < Base
        NYU_BOR_STATUS = {
          INSTITUTION_CODE: :NYU,
          STATUSES: %w(03 04 05 06 07 50 52 53 51 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 72 74 76 77)
        }
        NYUAD_BOR_STATUS = {
          INSTITUTION_CODE: :NYUAD,
          STATUSES: %w(80 81 82)
        }
        NYUSH_BOR_STATUS = {
          INSTITUTION_CODE: :NYUSH,
          STATUSES: %w(20 21 22 23)
        }
        CU_BOR_STATUS = {
          INSTITUTION_CODE: :CU,
          STATUSES: %w(10 11 12 15 16 17 18 20)
        }
        NS_BOR_STATUS = {
          INSTITUTION_CODE: :NS,
          STATUSES: %w(30 31 32 33 34 35 36 37 38 40 41 42 43)
        }
        NYSID_BOR_STATUS = {
          INSTITUTION_CODE: :NYSID,
          STATUSES: %w(90 95 96 97)
        }
        HSL_ILL_LIBRARY = {
          INSTITUTION_CODE: :HSL,
          STATUSES: %w(ILL_MED)
        }

        def initialize(omniauth_hash)
          super(omniauth_hash)
          @nyuidn = omniauth_hash.uid
          @institution_code = institute_for_bor_status(@omniauth_hash.extra.raw_info.bor_auth.z305.z305_bor_status)
          @properties = omniauth_hash.info.merge(properties_attributes)
        end

        ##
        # Override hash of extra attributes for merging into properties
        # Merges a new hash with wanted attributes with the parent hash.
        # Then merges again with the parent hash to get all the changes in parent.
        # The resulting hash will be have everything we want with no dupes.
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

        def institute_for_bor_status(bor_status)
          constants.each do |bor_status_const|
            return institution_code_for_const(bor_status_const) if statuses_for_const(bor_status_const).include?(bor_status)
          end
          return ""
        end

        def constants
          self.class.constants
        end

        def institution_code_for_const(bor_status_const)
          self.class.const_get(bor_status_const)[:INSTITUTION_CODE]
        end

        def statuses_for_const(bor_status_const)
          self.class.const_get(bor_status_const)[:STATUSES]
        end
      end
    end
  end
end
