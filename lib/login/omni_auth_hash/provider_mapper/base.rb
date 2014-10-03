##
# Base class sets default values for known attributes
# from passed in OmniAuth::AuthHash
module Login
  module OmniAuthHash
    module ProviderMapper
      class Base

        attr_reader :omniauth_hash, :provider, :uid, :username, :nyuidn, :email, :first_name, :last_name, :info, :properties, :institution_code

        def initialize(omniauth_hash)
          @omniauth_hash ||= omniauth_hash
          @provider ||= omniauth_hash.provider
          @uid ||= omniauth_hash.uid
          @username ||= omniauth_hash.uid
          @info ||= omniauth_hash.info
          @email ||= omniauth_hash.info.email
          @first_name ||= omniauth_hash.info.first_name
          @last_name ||= omniauth_hash.info.last_name
          @properties ||= omniauth_hash.info.merge(properties_attributes)
        end

        ##
        # Alias #to_h function to return
        # OmniAuth::AuthHash representation
        alias_method :to_h, :omniauth_hash

        ##
        # Define hash of extra attributes for merging into properties
        def properties_attributes
          {
            extra: extra_attributes,
            uid: uid,
            first_name: first_name,
            last_name: last_name,
            nyuidn: nyuidn,
            institution_code: institution_code
          }
        end

        def extra_attributes(options = {})
          extra.merge(options)
        end

        def extra
          (omniauth_hash.extra || {})
        end

      end
    end
  end
end
