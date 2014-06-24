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
        self.info.email
      end

      def properties
        self.info.merge(extra: @omniauth_hash_mapper.extra)
      end

      def username
        username = begin
          case self.provider
          when "twitter"
            self.info.nickname
          when "facebook"
            self.info.nickname || self.info.email
          when "new_school_ldap"
            self.email
          else
            self.uid
          end
        end
        username.downcase unless username.nil?
      end

      def to_hash
        @omniauth_hash_mapper
      end
      #
      # def method_missing(method_id, *args)
      #   if match = matches_valid_attr?(method_id)
      #     nil
      #   else
      #     super
      #   end
      # end
      #
      # def matches_valid_attr?(method_id)
      #   /^(uid|info|properties|email|provider|username)$/.match(method_id.to_s)
      # end

    end
  end
end
