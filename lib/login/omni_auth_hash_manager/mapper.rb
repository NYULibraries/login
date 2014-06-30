##
# Class to map an omniauth hash returned by a response in the environment
# into an object and make attribute decisions based on provider
module Login
  module OmniAuthHashManager
    class Mapper

      ##
      # Create a new mapper object from the omniauth hash
      # and delegate the validation to the validator class
      #
      # Example:
      #   Mapper.new(OmniAuth::AuthHash)
      def initialize(omniauth_hash)
        validator = Login::OmniAuthHashManager::Validator.new(omniauth_hash)
        @omniauth_hash_mapper = omniauth_hash
      end

      ##
      # Return the uid attribute
      def uid
        case @omniauth_hash_mapper.provider
        when "new_school_ldap"
          new_school_ldap_hash[:pdsloginid].first
        else
          @omniauth_hash_mapper.uid
        end
      end

      def new_school_ldap_hash
        eval(@omniauth_hash_mapper.extra.raw_info.dn)
      end

      ##
      # Return the provider attribute
      def provider
        @omniauth_hash_mapper.provider
      end

      ##
      # Return the info attribute, which is an OmniAuth::AuthHash::InfoHash
      def info
        @omniauth_hash_mapper.info
      end

      ##
      # Return the email attribute form the InfoHash
      def email
        @omniauth_hash_mapper.info.email
      end

      ##
      # Generate the properties hash from InfoHash and extra fields
      def properties
        @omniauth_hash_mapper.info.merge(extra_attributes)
      end

      ##
      # Define hash of extra attributes for merging into properties
      def extra_attributes
        {
          extra: @omniauth_hash_mapper.extra,
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

      ##
      # Get first name out of hash
      def first_name
        @omniauth_hash_mapper.info.first_name
      end

      ##
      # Get last name out of hash
      def last_name
        @omniauth_hash_mapper.info.last_name
      end

      ##
      # Get N# out of hash
      def nyuidn
        case @omniauth_hash_mapper.provider
        when "new_school_ldap"
          extract_value_from_keyed_array(new_school_ldap_hash[:pdsexternalsystemid], "sct")
        else
          @omniauth_hash_mapper.uid
        end
      end

      def extract_value_from_keyed_array(array, key)
        array.find { |val| /(.+)::#{key}/.match(val) }.split("::").first
      end

      ##
      # Return OmniAuth::AuthHash representation
      def to_hash
        @omniauth_hash_mapper
      end

    end
  end
end
