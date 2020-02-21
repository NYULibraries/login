module UserMacros
  def find_or_create_user_by_provider(provider)
    user = User.find_by(username: attributes_for("#{provider}_user")[:username], provider: attributes_for("#{provider}_user")[:provider])
    user ||= create("#{provider}_user", omniauth_hash_map: authhash_map_by_provider(attributes_for("#{provider}_user")[:provider]))
    user
  end

  def find_or_create_user_by_usertype(usertype)
    user = User.find_by(username: attributes_for("#{usertype}_user")[:username], provider: attributes_for("#{usertype}_user")[:provider])
    user ||= create("#{usertype}_user", omniauth_hash_map: authhash_map_by_usertype("#{usertype}"))
    user
  end

  def find_or_create_admin
    user = User.find_by(username: attributes_for(:admin)[:username], provider: attributes_for(:admin)[:provider])
    user ||= create(:admin, omniauth_hash_map: authhash_map_by_provider(attributes_for(:admin)[:provider]))
    user
  end
end
