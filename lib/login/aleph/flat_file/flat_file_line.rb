module Login
  module Aleph
    class FlatFile
      class FlatFileLine
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
            self.send("#{attribute}=", line_array.shift) unless line_array.empty?
          end
        end

        def to_patron
          Patron.new do |patron|
            ATTRIBUTES.each do |attribute|
              patron.send("#{attribute}=", self.send("#{attribute}")) if patron.respond_to?("#{attribute}=")
            end
          end
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
