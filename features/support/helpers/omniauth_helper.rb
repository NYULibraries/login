module LoginFeatures
  module OmniauthHelper
    def ensure_logout
      OmniAuth.config.mock_auth.clear
    end
  end
end
