# Generate an array of authorization groups a user 
# is a member of based on their patron statuses
#
module Login
  class AuthGroups
    NY_UNDERGRADUATE = %w{57 22 82 64}
    NY_GRADUATE = %w{54 55 61}

    attr_accessor :user

    def initialize(user)
      @user = user
    end

    def auth_groups(auth_groups=[])
      auth_groups.push("undergraduate") if NY_UNDERGRADUATE.include?(patron_status)
      auth_groups.push("graduate") if NY_GRADUATE.include?(patron_status)
      auth_groups
    end

  protected

    def patron_status
      @patron_status ||= aleph_identity&.properties.try(:[], 'patron_status')
    end

    def aleph_identity
      @aleph_identity ||= user&.identities&.select{ |i| i.provider === 'aleph' }&.first
    end
  end
end