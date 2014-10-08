module Login
  module Aleph
    class PatronLoader
      class BorInfoStrategy < Strategy

        def patron
          unless bor_info.error?
            @patron ||= Patron.new do |instance|
              instance.identifier = bor_info_body["z303"]["z303_id"]
              instance.status = bor_info_body["z305"]["z305_bor_status"]
              instance.type = bor_info_body["z305"]["z305_bor_type"]
              instance.ill_permission = bor_info_body["z305"]["z305_photo_permission"]
              instance.ill_library = bor_info_body["z303"]["z303_ill_library"]
              instance.plif_status = bor_info_body["z303"]["z303_birthplace"]
            end
          end
        end

      private

        def bor_info_body
          @bor_info_body ||= bor_info.response.body["bor_info"]
        end

        def bor_info
          @bor_info ||= Aleph::XService::BorInfo.new(identifier)
        end

      end
    end
  end
end
