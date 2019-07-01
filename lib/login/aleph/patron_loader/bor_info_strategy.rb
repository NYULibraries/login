module Login
  module Aleph
    class PatronLoader
      class BorInfoStrategy < Strategy

        # Patron.new expects a block, so we set the known values
        # that we retrieved from the ugly API response
        def patron
          unless bor_info.error?
            @patron ||= Patron.new do |instance|
              instance.identifier = bor_info_body.dig("z303", "z303_id")
              instance.patron_status = bor_info_body.dig("z305", "z305_bor_status")
              instance.patron_type = bor_info_body.dig("z305", "z305_bor_type")
              instance.ill_permission = bor_info_body.dig("z305", "z305_photo_permission")
              instance.ill_library = bor_info_body.dig("z303", "z303_ill_library")
              instance.plif_status = bor_info_body.dig("z303", "z303_birthplace")
              instance.bor_name = bor_info_body.dig("z303", "z303_name")
              instance.address = bor_address
            end
          end
        end

      private

        def bor_address
          {
            street_address: bor_info_body.dig("z304", "z304_address_1"),
            city: bor_info_body.dig("z304", "z304_address_2"),
            state: bor_info_body.dig("z304", "z304_address_3"),
            postal_code: bor_info_body.dig("z304", "z304_zip")
          }
        end

        # Convenience for extracting the body of the response, wherein lies what we desire
        def bor_info_body
          @bor_info_body ||= bor_info.response.body["bor_info"]
        end

        # Use the Aleph XServices to get the borrower info based on the unique ID
        def bor_info
          @bor_info ||= Aleph::XService::BorInfo.new(identifier)
        end

      end
    end
  end
end
