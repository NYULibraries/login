##
# Inherits default values for attributes from base class
# and overrides Aleph specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class Aleph < Base
        BOR_STATUS_MAPPINGS = [
          { "NYU"   => %w(03 04 05 06 07 50 52 53 51 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 72 74 76 77) },
          { "NYUAD" => %w(80 81 82) },
          { "NYUSH" => %w(20 21 22 23) },
          { "CU"    => %w(10 11 12 15 16 17 18 20) },
          { "NS"    => %w(30 31 32 33 34 35 36 37 38 40 41 42 43) },
          { "NYSID" => %w(90 95 96 97) }
        ]
        ILL_LIBRARY_MAPPINGS = [
          {"HSL" => %w(ILL_MED)}
        ]

        def initialize(omniauth_hash)
          super(omniauth_hash)
          @nyuidn = omniauth_hash.uid
          bor_status = @omniauth_hash.extra.raw_info.bor_auth.z305.z305_bor_status
          ill_library = @omniauth_hash.extra.raw_info.bor_auth.z303.z303_ill_library
          @institution_code = (institute_for_bor_status(ill_library) || institute_for_bor_status(bor_status))
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

        def institute_for_ill_library(ill_library)
          ILL_LIBRARY_MAPPINGS.find do |ill_library_mapping|
            ill_library_mapping.find do |institution_code,ill_libraries|
              return institution_code if ill_libraries.include?(ill_library)
            end
          end
        end

        def institute_for_bor_status(bor_status)
          BOR_STATUS_MAPPINGS.find do |bor_status_mapping|
            bor_status_mapping.find do |institution_code,bor_statuses|
              return institution_code if bor_statuses.include?(bor_status)
            end
          end
        end
      end
    end
  end
end
