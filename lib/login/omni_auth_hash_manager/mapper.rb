##
module Login
  module OmniAuthHashManager
    class Mapper

      def initialize(omniauth_hash)
        validator = Login::OmniAuthHashManager::Validator.new(omniauth_hash)
        @omniauth_hash_mapper = omniauth_hash
      end

      def uid
        @omniauth_hash_mapper.uid
      end

      def provider
        @omniauth_hash_mapper.provider
      end

      def info
        @omniauth_hash_mapper.info
      end

      def email
        @omniauth_hash_mapper.info.email
      end

      def properties
        @omniauth_hash_mapper.info.merge(extra: @omniauth_hash_mapper.extra)
      end

      def username
        username = begin
          case @omniauth_hash_mapper.provider
          when "twitter"
            @omniauth_hash_mapper.info.nickname
          when "facebook"
            @omniauth_hash_mapper.info.nickname || @omniauth_hash_mapper.info.email
          when "new_school_ldap"
            @omniauth_hash_mapper.info.email
          else
            @omniauth_hash_mapper.uid
          end
        end
        username.downcase unless username.nil?
      end

      def to_hash
        @omniauth_hash_mapper
      end

    end
  end
end
