module OmniAuthHashMacros
  def authhash(provider)
    authhash = OmniAuth::AuthHash.new
    attributes = attributes_for("#{provider}_identity")
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

  def infohash(source_hash)
    OmniAuth::AuthHash::InfoHash.new(source_hash)
  end
end
