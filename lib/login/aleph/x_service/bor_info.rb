module Login
  module Aleph
    module XService
      class BorInfo < Base
        attr_accessor :identifier, :op

        DEFAULT_SHOW_LOANS_VALUE = "N"
        DEFAULT_SHOW_CASH_VALUE = "N"

        def initialize(identifier)
          @identifier = identifier
          @op = "bor_info"
          super()
        end

        def error
          @error ||= response.body[op]["error"]
        end

        def error?
          error.present?
        end

      protected

        def options
          @options ||= super.merge({
            loans: DEFAULT_SHOW_LOANS_VALUE,
            cash: DEFAULT_SHOW_CASH_VALUE
          })
        end

      end
    end
  end
end
