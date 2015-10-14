module Login
  module Aleph
    class Name
      attr_accessor :first_name, :last_name, :fullname, :default_value

      # First name has to have some value for PDS to work
      # so either parse the actual name or use the default_value,
      # which could be the identifier
      def initialize(fullname, default_value)
        if fullname.blank? && default_value.blank?
          raise ArgumentError.new("Fullname or default_value argument is required.")
        end
        @fullname = fullname
        @default_value = default_value
        @last_name = get_last_name
        @first_name = get_first_name
      end

      ##
      # Extract the firstname from an array of the name split by comma
      # Given name = 'SMITH, JOHN', then names_array.last === first_name
      def get_first_name
        @get_first_name ||= (names_array.last.present?) ? names_array.last : default_value
      end
      private :get_first_name

      ##
      # Extract the lastname from an array of the name split by comma
      # Given name = 'SMITH, JOHN', then names_array.first === last_name
      def get_last_name
        @get_last_name ||= clean_name(names_array.first)
      end
      private :get_last_name

      # Split name from format 'SMITH, JOHN' to array ['SMITH','JON']
      # Also strip whitespace
      def names_array
        @names_array ||= fullname.split(',').map(&:strip)
      end
      private :names_array

      # Clean messy characters out of name
      def clean_name(name)
        if name.present?
          name.gsub(/(\s|-|\.|,)/,'')
        end
      end
      private :clean_name

    end
  end
end
