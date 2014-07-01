##
# Class to validate an OmniAuth hash for different conditions
# and raise an ArgumentError if it's not
module Login
  module OmniAuthHash
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
      def initialize(omniauth_hash, provider)
        @omniauth_hash = omniauth_hash
        @provider = provider
        raise ArgumentError.new(omniauth_hash) unless self.valid?
      end

      ##
      # Return boolean if hash is valid
      def valid?
        @omniauth_hash.present? && @omniauth_hash.is_a?(OmniAuth::AuthHash) && @omniauth_hash.provider == @provider
      end

    end
  end
end
