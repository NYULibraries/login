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
        @omniauth_hash = omniauth_hash
        raise ArgumentError.new(omniauth_hash) unless @omniauth_hash.present? && @omniauth_hash.is_a?(OmniAuth::AuthHash)
      end

      ##
      # Return the uid attribute
      def uid
        case @omniauth_hash.provider
        when "new_school_ldap"
          new_school_ldap_hash[:pdsloginid].first
        else
          @omniauth_hash.uid
        end
      end

      def new_school_ldap_hash
        eval(@omniauth_hash.extra.raw_info.dn)
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

      ##
      # Generate the properties hash from InfoHash and extra fields
      def properties
        @omniauth_hash.info.merge(extra_attributes)
      end

      ##
      # Define hash of extra attributes for merging into properties
      def extra_attributes
        {
          extra: @omniauth_hash.extra,
          uid: self.uid,
          first_name: first_name,
          last_name: last_name,
          nyuidn: nyuidn
        }
      end

      ##
      # Return username attr based on provider
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

      ##
      # Get first name out of hash
      def first_name
        @omniauth_hash.info.first_name
      end

      ##
      # Get last name out of hash
      def last_name
        @omniauth_hash.info.last_name
      end

      ##
      # Get N# out of hash
      def nyuidn
        case @omniauth_hash.provider
        when "new_school_ldap"
          extract_value_from_keyed_array(new_school_ldap_hash[:pdsexternalsystemid], "sct")
        else
          @omniauth_hash.uid
        end
      end

      def extract_value_from_keyed_array(array, key)
        array.find { |val| /(.+)::#{key}/.match(val) }.split("::").first
      end

      ##
      # Return OmniAuth::AuthHash representation
      def to_hash
        @omniauth_hash
      end

    end
  end
end
