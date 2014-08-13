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

      def to_h
        @to_h ||= HashWithIndifferentAccess[instance_variables.collect {|var| [var.to_s.delete("@").to_sym, instance_variable_get(var)] }]
      end
      alias_method :attributes, :to_h
    end
  end
end
