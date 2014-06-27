module OmniAuthHashMacros
  def authhash(provider)
    authhash = OmniAuth::AuthHash.new
    attributes = (FactoryGirl.factories.registered?("#{provider}_identity")) ? attributes_for("#{provider}_identity") : attributes_for(:invalid_identity, provider: provider)
    authhash.uid = attributes[:uid]
    authhash.provider = "#{provider}"
    properties = attributes[:properties]
    name = properties[:name]
    email = properties[:email]
    nickname = properties[:nickname]
    phone = properties[:phone]
    authhash.info =
      infohash({ name: name, email: email, nickname: nickname, phone: phone })
    authhash
  end

  def authhash_map(provider)
    Login::OmniAuthHash::Mapper.new(authhash(provider))
  end

  def infohash(source_hash)
    OmniAuth::AuthHash::InfoHash.new(source_hash)
  end
end
