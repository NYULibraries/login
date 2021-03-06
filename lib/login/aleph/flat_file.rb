module Login
  module Aleph
    class FlatFile
      attr_reader :location, :encoding
      def initialize(location, encoding="UTF-8")
        raise ArgumentError, 'location cannot be nil' if location.nil?
        raise ArgumentError, 'File not found!' unless File.exist?(location)
        @location = location
        @encoding = encoding
      end

      def find_patron_by_identifier(identifier)
        raise Errno::ENOENT unless location && File.exist?(location)
        flat_file_line = nil
        File.open(location,"r:#{encoding}") do |file|
          file.each_line do |line|
            line.chomp!
            next unless line.downcase[identifier.downcase]
            flat_file_line = FlatFileLine.new(line)
            break if flat_file_line.matches_identifier?(identifier)
            flat_file_line = nil
          end
        end
        flat_file_line.to_patron unless flat_file_line.nil?
      end
    end
  end
end
