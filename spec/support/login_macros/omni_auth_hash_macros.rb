module OmniAuthHashMacros
  def authhash(provider, usertype = nil)
    if FactoryBot.factories.registered?("#{usertype}_authhash")
      FactoryBot.create("#{usertype}_authhash")
    elsif FactoryBot.factories.registered?("#{provider}_authhash")
      FactoryBot.create("#{provider}_authhash")
    else
      FactoryBot.create(:invalid_provider_authhash, provider: provider)
    end
  end

  def authhash_map_by_provider(provider)
    Login::OmniAuthHash::Mapper.new(authhash(provider))
  end

  def authhash_map_by_usertype(usertype)
    Login::OmniAuthHash::Mapper.new(authhash(FactoryBot.attributes_for("#{usertype}_user")[:provider], usertype))
  end

  def infohash(source_hash)
    OmniAuth::AuthHash::InfoHash.new(source_hash)
  end
end
