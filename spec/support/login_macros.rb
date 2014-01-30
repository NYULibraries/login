module LoginMacros
  def login_user
    before(:each) do |example|
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.find_by(username: attributes_for(:user)[:username], provider: attributes_for(:user)[:provider])
      user ||= create(:user)
      sign_in user
    end
  end
end
