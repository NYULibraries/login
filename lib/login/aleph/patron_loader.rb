module Login
  module Aleph
    class PatronLoader
      attr_reader :identifier

      def initialize(identifier)
        @identifier = identifier
      end
    end
  end
end
