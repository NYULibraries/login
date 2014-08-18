module Login
  module Aleph
    class PatronLoader
      class FlatFileStrategy < Strategy
        ATTRIBUTES = [:identifier, :barcode, :verification, :expiry_date,
          :status, :type, :bor_name, :email, :ill_permission, :plif_status,
          :college_code, :college, :dept_code, :department, :major_code,
          :major, :ill_library]
        NEW_LINE = "\n"
        DELIMITER = "\t"
        def patron
          @patron ||= Patron.new do |instance|
            map_accessors_to_values.each_pair do |key, value|
              instance.send("#{key}=",value) if instance.respond_to?(key)
            end
          end
        end

        private

        def matches_from_flat_file
          File.readlines(ENV["FLAT_FILE"]).select { |line| line =~ Regexp.new(identifier) }
        end

        def line_from_flat_file
          clean_line(matches_from_flat_file.first) || []
        end

        def clean_line(line)
          line.gsub(NEW_LINE,"").split(DELIMITER) unless line.nil?
        end

        def map_accessors_to_values
          Hash[ATTRIBUTES.zip(line_from_flat_file.map)]
        end
      end
    end
  end
end
