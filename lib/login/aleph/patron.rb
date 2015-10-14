module Login
  module Aleph
    class Patron
      BOR_STATUS_MAPPINGS = [
        { "NYU"   => %w(03 04 05 06 07 50 52 53 51 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 72 74 76 77) },
        { "NYUAD" => %w(80 81 82) },
        { "NYUSH" => %w(20 21 22 23) },
        { "CU"    => %w(10 11 12 15 16 17 18 20) },
        { "NS"    => %w(30 31 32 33 34 35 36 37 38 40 41 42 43) },
        { "NYSID" => %w(90 95 96 97) }
      ]
      ILL_LIBRARY_MAPPINGS = [
        {"HSL" => %w(ILL_MED)}
      ]
      DEFAULT_INSTITUTION = "NYU"

      # Attributes that any patron object will have
      # It is important to note that this cascades to user identities
      # If an attribute is not accessible on the patron object,
      # the Aleph identity for any user will not have access to that attribute
      attr_accessor :identifier, :verification, :barcode, :patron_status, :patron_type,
      :ill_permission, :college, :department, :dept_code, :major, :major_code, :plif_status,
      :ill_library, :institution_code, :expiry_date, :bor_name, :first_name, :last_name

      def initialize(&block)
        unless block_given?
          raise ArgumentError.new("Expecting a block to be given!")
        end
        yield self
        # Favor the institution for ILL Library, since it is more accurate,
        # Then use the borrower status to map to an institution
        # Or default to NYU
        @institution_code ||= (institution_for_ill_library || institution_for_bor_status || DEFAULT_INSTITUTION)
        @first_name ||= aleph_names.first_name
        @last_name ||= aleph_names.last_name
      end

      ##
      # Take the instance variables from this object and map them into a hash
      #
      # Ex.
      #
      # => @patron = #<Login::Aleph::Patron:0x00 @identifier="NXXX", @ill_library="ZYU", @ill_permission="Y", @plif_status="PLIF LOADED", @status="60", @type="CB">
      # => @patron.to_h => {"identifier"=>"NXXX", "status"=>"60", "type"=>"CB", "ill_permission"=>"Y", "ill_library"=>"ZYU", "plif_status"=>"PLIF LOADED"}
      def to_h
        @to_h ||= HashWithIndifferentAccess[instance_variables.collect {|var| [var.to_s.delete("@").to_sym, instance_variable_get(var)] }]
      end
      alias_method :attributes, :to_h

      def institution_for_ill_library
        ILL_LIBRARY_MAPPINGS.find do |ill_library_mapping|
          ill_library_mapping.find do |institution_code,ill_libraries|
            return institution_code if ill_libraries.include?(ill_library)
          end
        end
      end
      private :institution_for_ill_library

      def institution_for_bor_status
        BOR_STATUS_MAPPINGS.find do |bor_status_mapping|
          bor_status_mapping.find do |institution_code,bor_statuses|
            return institution_code if bor_statuses.include?(patron_status)
          end
        end
      end
      private :institution_for_bor_status

      def aleph_names
        aleph_names = Login::Aleph::Name.new(self.bor_name, self.identifier)
      end
      private :aleph_names
    end
  end
end
