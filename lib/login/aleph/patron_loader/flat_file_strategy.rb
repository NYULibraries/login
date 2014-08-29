module Login
  module Aleph
    class PatronLoader
      class FlatFileStrategy < Strategy
        def patron
          @patron ||= flat_file_line.to_patron unless flat_file_line.nil?
        end

        private
        def flat_file
          @flat_file ||= Aleph::FlatFile::FlatFileLoader.new(ENV["FLAT_FILE"])
        end

        def flat_file_line
          @flat_file_line ||= flat_file.find_line_by_identity(identifier)
        end
      end
    end
  end
end
