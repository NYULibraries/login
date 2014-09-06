module Login
  module Aleph
    class PatronLoader
      class Strategy
        attr_reader :identifier

        def initialize(identifier)
          @identifier = identifier
        end
      end
    end
  end
end
