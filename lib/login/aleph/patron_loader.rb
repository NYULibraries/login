module Login
  module Aleph
    class PatronLoader
      attr_reader :identifier

      # flat_file_strategy is deprecated since its information is no longer necessary for login functionality.
      FLAT_FILE_STRATEGY_ENABLED = ENV['FLAT_FILE_STRATEGY_ENABLED'] || false

      def initialize(identifier)
        @identifier = identifier
      end

      def patron
        FLAT_FILE_STRATEGY_ENABLED ? flat_file_strategy.patron : bor_info_strategy.patron
      end

    private

      def bor_info_strategy
        @bor_info_strategy ||= BorInfoStrategy.new(identifier)
      end

      def flat_file_strategy
        @flat_file_strategy ||= FlatFileStrategy.new(identifier)
      end
    end
  end
end
