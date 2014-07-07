##
# Inherits default values for attributes from base class
# and overrides NYU Shibboleth specific ones
module Login
  module OmniAuthHash
    module ProviderMapper
      class NYUShibboleth < Base
      end
    end
  end
end
