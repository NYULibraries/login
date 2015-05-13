module UserMacros
  def find_or_create_user(provider)
    user = User.find_by(username: attributes_for("#{provider}_user")[:username], provider: attributes_for("#{provider}_user")[:provider])
    user ||= create("#{provider}_user", omniauth_hash_map: authhash_map(attributes_for("#{provider}_user")[:provider]))
    user
  end

  def find_or_create_admin
    user = User.find_by(username: attributes_for(:admin)[:username], provider: attributes_for(:admin)[:provider])
    user ||= create(:admin, omniauth_hash_map: authhash_map(attributes_for(:admin)[:provider]))
    user
  end
end
