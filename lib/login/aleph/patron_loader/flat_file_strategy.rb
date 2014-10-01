module Login
  module Aleph
    class PatronLoader
      class FlatFileStrategy < Strategy
        def patron
          @patron ||= patron_from_flat_file unless patron_from_flat_file.nil?
        end

        private
        def flat_file
          @flat_file ||= Aleph::FlatFile.new(ENV["FLAT_FILE"], "ISO-8859-1")
        end

        def patron_from_flat_file
          @patron_from_flat_file ||= flat_file.find_patron_by_identifier(identifier)
        end
      end
    end
  end
end
