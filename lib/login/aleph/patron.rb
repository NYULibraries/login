module Login
  module Aleph
    class Patron
      attr_accessor :identifier, :status, :type, :ill_permission, :college,
        :department, :major, :plif_status

      def initialize(&block)
        unless block_given?
          raise ArgumentError.new("Expecting a block to be given!")
        end
        yield self
      end
    end
  end
end
