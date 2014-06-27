##
module Login
  module OmniAuthHash
    class Mapper

      class ArgumentError < ::ArgumentError
        def initialize(omniauth_hash)
          super("#{omniauth_hash} is not a valid OmniAuth::AuthHash")
        end
      end

      def initialize(omniauth_hash)
        @omniauth_hash = omniauth_hash
        raise ArgumentError.new(omniauth_hash) unless @omniauth_hash.present? && @omniauth_hash.is_a?(OmniAuth::AuthHash)
      end

      def uid
        @omniauth_hash.uid
      end

      def provider
        @omniauth_hash.provider
      end

      def info
        @omniauth_hash.info
      end

      def email
        @omniauth_hash.info.email
      end

      def properties
        @omniauth_hash.info.merge(extra: @omniauth_hash.extra)
      end

      def username
        username = begin
          case @omniauth_hash.provider
          when "twitter"
            @omniauth_hash.info.nickname
          when "facebook"
            @omniauth_hash.info.nickname || @omniauth_hash.info.email
          when "new_school_ldap"
            @omniauth_hash.info.email
          else
            @omniauth_hash.uid
          end
        end
        username.downcase unless username.nil?
      end

      def to_hash
        @omniauth_hash
      end

    end
  end
end
