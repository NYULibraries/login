module Login
  module Aleph
    class FlatFile
      class FlatFileLine
        # An ordered list of the tab-delimited values found in the flat file
        ATTRIBUTES = [:identifier, :barcode, :verification, :expiry_date,
          :patron_status, :patron_type, :bor_name, :email, :ill_permission, :plif_status,
          :college_code, :college, :dept_code, :department, :major_code,
          :major, :ill_library]
        attr_reader *ATTRIBUTES
        DELIMITER = "\t"

        def initialize(line)
          return if line.nil?
          line_array = line_to_array(line.chomp)
          ATTRIBUTES.each do |attribute|
            break if line_array.empty?
            self.send("#{attribute}=", line_array.shift)
          end
        end

        # Turn a line in the flat file into a patron object
        # Note that this sets all the above attributes on the new object
        # only if Patron has an attr_accessor for that attribute
        def to_patron
          Patron.new do |patron|
            ATTRIBUTES.each do |attribute|
              # => if patron.respond_to?("expiry_date=") == false => patron.expiry_date == nil
              patron.send("#{attribute}=", self.send("#{attribute}")) if patron.respond_to?("#{attribute}=")
            end
          end
        end

        # Look up by identifier or barcode
        # If none of the cases match or any of the fields are missing, it's a no
        def matches_identifier?(identifier)
          (self.identifier.try(:upcase) == identifier.upcase || self.barcode.try(:upcase) == identifier.upcase)
        end

        private

        attr_writer *ATTRIBUTES

        def patron_type=(raw_type)
          @patron_type = raw_type.eql?("0") ? nil : raw_type
        end

        def line_to_array(line)
          line.split(DELIMITER)
        end
      end
    end
  end
end
