module UserMacros
  def find_or_create_user(factory_name = nil)
    user = User.find_by(username: attributes_for(:user)[:username], provider: attributes_for(:user)[:provider])
    user ||= create(:user)
    user.identities = [create(factory_name)] unless factory_name.nil?
    user
  end

  def find_or_create_admin
    user = User.find_by(username: attributes_for(:admin)[:username], provider: attributes_for(:admin)[:provider])
    user ||= create(:admin)
    user
  end
end
