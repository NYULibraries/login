##
# Base class sets default values for known attributes
# from passed in OmniAuth::AuthHash
module Login
  module OmniAuthHash
    module ProviderMapper
      class Base

        attr_reader :provider, :uid, :username, :nyuidn, :email, :first_name, :last_name, :info, :properties

        def initialize(omniauth_hash)
          @omniauth_hash = omniauth_hash
          @provider = @omniauth_hash.provider
          @uid = @omniauth_hash.uid
          @username = @uid
          @nyuidn = @uid
          @info = @omniauth_hash.info
          @email = @info.email
          @first_name = @info.first_name
          @last_name = @info.last_name
          @properties = @info.merge(extra_attributes)
        end

        ##
        # Return OmniAuth::AuthHash representation
        def to_hash
          @omniauth_hash
        end

        ##
        # Define hash of extra attributes for merging into properties
        def extra_attributes
          @extra_attributes ||= {
            extra: @omniauth_hash.extra,
            uid: self.uid,
            first_name: first_name,
            last_name: last_name,
            nyuidn: nyuidn
          }
        end

      end
    end
  end
end
