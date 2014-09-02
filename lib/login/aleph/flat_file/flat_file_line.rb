module Login
  module Aleph
    module FlatFile
      class FlatFileLine
        ATTRIBUTES = [:identifier, :barcode, :verification, :expiry_date,
          :status, :type, :bor_name, :email, :ill_permission, :plif_status,
          :college_code, :college, :dept_code, :department, :major_code,
          :major, :ill_library]
        attr_accessor *ATTRIBUTES
        NEW_LINE = "\n"
        DELIMITER = "\t"

        def initialize(line)
          return if line.nil?
          line_array = line_to_array(clean_new_line(line))
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

        def type=(raw_type)
          @type = raw_type.eql?("0") ? nil : raw_type 
        end

        private

        def clean_new_line(line)
          line.gsub(NEW_LINE,"")
        end

        def line_to_array(line)
          line.split(DELIMITER)
        end
      end
    end
  end
end
