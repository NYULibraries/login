##
# Class to map an omniauth hash returned by a response in the environment
# into an object and make attribute decisions based on provider
module Login
  module OmniAuthHash
    class Mapper

      # Raise an argument error when there is an invalid hash
      class ArgumentError < ::ArgumentError
        def initialize(omniauth_hash, provider = nil)
          if provider
            super("#{provider.classify} is not a valid identity provider")
          else
            super("#{omniauth_hash} is not a valid OmniAuth::AuthHash")
          end
        end
      end

      ##
      # Create a new mapper object from the omniauth hash
      # and delegate the validation to the validator class
      #
      # Example:
      #   Mapper.new(OmniAuth::AuthHash)
      def initialize(omniauth_hash)
        # Raise error if in valid OmniAuth::AuthHash
        unless omniauth_hash.present? && omniauth_hash.is_a?(OmniAuth::AuthHash)
          raise ArgumentError.new(omniauth_hash)
        end
        # Raise error if provider is not whitelisted
        unless matches_provider_whitelist?(omniauth_hash.provider)
          raise ArgumentError.new(omniauth_hash, omniauth_hash.provider)
        end
        # Set instance vars
        @omniauth_hash = omniauth_hash
        # Generate the provider mapper from the provider, so we can delegate all calls to it
        @provider_mapper = "Login::OmniAuthHash::ProviderMapper::#{@omniauth_hash.provider.classify}".safe_constantize.new(@omniauth_hash)
      end

      # Delegate all calls to @provider_mapper
      extend Forwardable
      def_delegators :@provider_mapper, :omniauth_hash, :provider, :uid, :username, :nyuidn, :email, :first_name, :last_name, :info, :properties, :to_h

      def matches_provider_whitelist?(provider)
        provider.present? && whitelist_providers.include?(provider.to_sym)
      end
      private :matches_provider_whitelist?

      # Static whitelist of valid identity providers
      def whitelist_providers
        [:new_school_ldap, :twitter, :nyu_shibboleth, :facebook, :aleph]
      end
      private :whitelist_providers

    end
  end
end
