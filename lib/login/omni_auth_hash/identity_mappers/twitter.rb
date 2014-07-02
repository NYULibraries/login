##
#
module Login
  module OmniAuthHash
    module IdentityMappers
      class Twitter < Login::OmniAuthHash::IdentityMappers::Base
        def initialize(omniauth_hash)
          super(omniauth_hash)
        end
        def username
          @omniauth_hash.info.nickname
        end
      end
    end
  end
end
