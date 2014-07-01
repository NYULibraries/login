##
#
module Login
  module OmniAuthHash
    module Providers
      class Twitter < Login::OmniAuthHash::Providers::Base

        def username
          @omniauth_hash.info.nickname
        end

      end
    end
  end
end
