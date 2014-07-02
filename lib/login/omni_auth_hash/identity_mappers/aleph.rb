##
# Inherits default values for attributes from base class
# and overrides Aleph specific ones
module Login
  module OmniAuthHash
    module IdentityMappers
      class Aleph < Login::OmniAuthHash::IdentityMappers::Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
        end
      end
    end
  end
end
