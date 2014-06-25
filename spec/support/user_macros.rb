module UserMacros
  def find_or_create_user
    user = User.find_by(username: attributes_for(:user)[:username], provider: attributes_for(:user)[:provider])
    user ||= create(:user, omniauth_hash_map: authhash_map(attributes_for(:user)[:provider]))
    user
  end

  def find_or_create_admin
    user = User.find_by(username: attributes_for(:admin)[:username], provider: attributes_for(:admin)[:provider])
    user ||= create(:admin, omniauth_hash_map: authhash_map(attributes_for(:user)[:provider]))
    user
  end
end
