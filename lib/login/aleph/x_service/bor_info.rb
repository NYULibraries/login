module Login
  module Aleph
    module XService
      class BorInfo < Base
        attr_accessor :identifier, :library

        DEFAULT_SHOW_LOANS_VALUE = "N"
        DEFAULT_SHOW_CASH_VALUE = "N"

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

        def options
          @options ||= super.merge({
            loans: DEFAULT_SHOW_LOANS_VALUE,
            cash: DEFAULT_SHOW_CASH_VALUE
          })
        end

      protected

        def op
          @op ||= "bor_info"
        end

      end
    end
  end
end
