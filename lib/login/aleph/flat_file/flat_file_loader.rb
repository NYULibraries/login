module Login
  module Aleph
    module FlatFile
      class FlatFileLoader
        def initialize(location)
          @location = location
        end

        def find_line_by_identity(identifier)
          raise Errno::ENOENT unless flat_file_exists
          flat_file_line = nil
          File.open(@location,'r') do |file|
            while line = file.gets
              flat_file_line = FlatFileLine.new(line) if line =~ Regexp.new(identifier)
            end
          end
          flat_file_line
        end

        private
        def flat_file_exists
          File.exist?(@location) && @location
        end
      end
    end
  end
end
