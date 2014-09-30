module Login
  module Aleph
    class FlatFile
      attr_reader :location
      def initialize(location, encoding="UTF-8")
        raise ArgumentError, 'location cannot be nil' if location.nil?
        raise ArgumentError, 'File not found!' unless File.exist?(location)
        @location = location
        @encoding = encoding
      end

      def find_patron_by_identifier(identifier)
        raise Errno::ENOENT unless location && File.exist?(location)
        flat_file_line = nil
        File.open(location,"r:#{@encoding}") do |file|
          while line = file.gets
            flat_file_line = FlatFileLine.new(line)
            break if flat_file_line.identifier.eql?(identifier)
            flat_file_line = nil
          end
        end
        flat_file_line.to_patron unless flat_file_line.nil?
      end
    end
  end
end
