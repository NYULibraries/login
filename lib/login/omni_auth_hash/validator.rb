##
module Login
  module OmniAuthHash
    class Validator

      class ArgumentError < ::ArgumentError
        def initialize(omniauth_hash)
          super("#{omniauth_hash} is not a valid OmniAuth::AuthHash")
        end
      end

      def initialize(omniauth_hash, provider)
        @omniauth_hash = omniauth_hash
        @provider = provider
        raise ArgumentError.new(omniauth_hash) unless self.valid?
      end

      def valid?
        @omniauth_hash.present? && @omniauth_hash.is_a?(OmniAuth::AuthHash) && @omniauth_hash.provider == @provider
      end

    end
  end
end
