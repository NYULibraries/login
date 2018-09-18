module LoginFeatures
  module Ezborrow
    def set_flat_file(location)
      ENV['FLAT_FILE'] = location
    end
  end
end
