module OmniAuthHashHelper
  def self.included(klass)
    klass.class_eval do
      attr_accessor :omniauth_hash
    end
  end

  def omniauth_hash?
    omniauth_hash.present? && 
      omniauth_hash.is_a?(OmniAuth::AuthHash)
  end

  def omniauth_uid
    omniauth_hash.uid if omniauth_hash?
  end

  def omniauth_provider
    omniauth_hash.provider if omniauth_hash?
  end

  def omniauth_info
    omniauth_hash.info if omniauth_hash?
  end

  def omniauth_email
    omniauth_info.email if omniauth_hash?
  end

  def omniauth_properties
    omniauth_hash.info.merge(extra: omniauth_hash.extra) if omniauth_hash?
  end

  def omniauth_username
    if omniauth_hash?
      @omniauth_username ||= case omniauth_provider
        when "twitter", "facebook"
          omniauth_info.nickname
        else
          omniauth_uid
        end.downcase
    end
  end
end