module Login
  module Aleph
    class PatronLoader
      attr_reader :identifier

      def initialize(identifier)
        @identifier = identifier
      end

      def patron
        bor_info_strategy.patron || flat_file_strategy.patron
      end

    private

      def bor_info_strategy
        @bor_info_strategy ||= BorInfoStrategy.new(identifier)
      end

      def flat_file_strategy
      end
    end
  end
end
