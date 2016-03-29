module OmniAuthHashMacros
  def authhash(provider)
    if FactoryGirl.factories.registered?("#{provider}_authhash")
      FactoryGirl.create("#{provider}_authhash")
    else
      FactoryGirl.create(:invalid_provider_authhash, provider: provider)
    end
  end

  def authhash_map(provider)
    Login::OmniAuthHash::Mapper.new(authhash(provider))
  end

  def infohash(source_hash)
    OmniAuth::AuthHash::InfoHash.new(source_hash)
  end
end
