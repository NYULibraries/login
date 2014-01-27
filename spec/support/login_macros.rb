module LoginMacros
  def login_user
    before(:each) do |example|
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.where(username: attributes_for(:user)[:username]).first
      user ||= create(:user)
      sign_in user
    end
  end
end
