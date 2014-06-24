##
module Login
  module OmniAuthHashManager
    class Validator

      class ArgumentError < ::ArgumentError
        def initialize(omniauth_hash)
          super("#{omniauth_hash} is not a valid OmniAuth::AuthHash")
        end
      end

      def initialize(omniauth_hash, provider = nil)
        @omniauth_hash = omniauth_hash
        @provider = provider if provider
        raise ArgumentError.new(omniauth_hash) unless self.valid?
      end

      def valid?
        (@provider) ? self.valid_for_action? : self.valid_hash?
      end

      def valid_for_action?
        self.valid_hash? && @omniauth_hash.provider == @provider
      end

      def valid_hash?
        @omniauth_hash.present? && @omniauth_hash.is_a?(OmniAuth::AuthHash)
      end

    end
  end
end
