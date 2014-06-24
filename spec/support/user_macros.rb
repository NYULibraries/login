module UserMacros
  def find_or_create_user(factory_name = :user)
    user = User.find_by(username: attributes_for(factory_name)[:username], provider: attributes_for(factory_name)[:provider])
    user ||= create(factory_name)
    user
  end

  def find_or_create_admin
    user = User.find_by(username: attributes_for(:admin)[:username], provider: attributes_for(:admin)[:provider])
    user ||= create(:admin)
    user
  end
end
