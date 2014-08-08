module Login
  module Aleph
    module XService
      class BorInfo < Base
        attr_accessor :identifier, :library

        def initialize(identifier, library = ENV["ALEPH_XSERVICE_LIBRARY"])
          @identifier = identifier
          @library = library
          super()
        end

        def error
          @error ||= response.body[op]["error"]
        end

        def error?
          error.present?
        end

      protected

        def op
          @op ||= "bor_info"
        end

      end
    end
  end
end
