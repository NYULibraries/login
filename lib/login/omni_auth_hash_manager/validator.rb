##
# Class to validate an OmniAuth hash for different conditions
# and raise an ArgumentError if it's not
module Login
  module OmniAuthHashManager
    class Validator

      # Call this error if omniauth hash is invalid
      # handle it as a global catch in the application controller
      class ArgumentError < ::ArgumentError
        def initialize(omniauth_hash)
          super("#{omniauth_hash} is not a valid OmniAuth::AuthHash")
        end
      end

      ##
      # Create a new validator object with an OmniAuth::AuthHash and an optional provider
      # and raise and ArgumentError if the hash is invalid
      #
      # Example:
      #   Validator.new(OmniAuth::AuthHash, 'nyu_shibboleth|newschool_ldap|twitter|facebook|etc')
      def initialize(omniauth_hash, provider = nil)
        @omniauth_hash = omniauth_hash
        @provider = provider if provider
        raise ArgumentError.new(omniauth_hash) unless self.valid?
      end

      ##
      # Return boolean if hash is valid
      def valid?
        (@provider) ? self.valid_for_action? : self.valid_hash?
      end

      ##
      # If provider is present make sure it matches the provider from the hash
      def valid_for_action?
        self.valid_hash? && @omniauth_hash.provider == @provider
      end

      ##
      # Validate the hash's presence and type
      def valid_hash?
        @omniauth_hash.present? && @omniauth_hash.is_a?(OmniAuth::AuthHash)
      end

    end
  end
end
