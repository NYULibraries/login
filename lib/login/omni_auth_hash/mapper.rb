##
# Class to map an omniauth hash returned by a response in the environment
# into an object and make attribute decisions based on provider
module Login
  module OmniAuthHash
    class Mapper

      class ArgumentError < ::ArgumentError
        def initialize(omniauth_hash)
          super("#{omniauth_hash} is not a valid OmniAuth::AuthHash")
        end
      end

      ##
      # Create a new mapper object from the omniauth hash
      # and delegate the validation to the validator class
      #
      # Example:
      #   Mapper.new(OmniAuth::AuthHash)
      def initialize(omniauth_hash)
        raise ArgumentError.new(omniauth_hash) unless omniauth_hash.present? && omniauth_hash.is_a?(OmniAuth::AuthHash)
        @omniauth_hash = omniauth_hash
      end

      def method_missing(method_id, *args)
        if match = matches_provider_whitelist?(@omniauth_hash.provider)
          instance_variable_set("@#{@omniauth_hash.provider}_mapper", "Login::OmniAuthHash::IdentityMappers::#{@omniauth_hash.provider.classify}".constantize.new(@omniauth_hash))
          instance_variable_get("@#{@omniauth_hash.provider}_mapper").send(method_id)
        else
          super
        end
      end

      def matches_provider_whitelist?(provider)
        whitelist_providers.include? provider.to_sym
      end
      private :matches_provider_whitelist?

      def whitelist_providers
        [:new_school_ldap, :twitter, :nyu_shibboleth, :facebook, :aleph]
      end

    end
  end
end
