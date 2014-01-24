module ControllerMacros
  def login_user
    before(:each) do |example|
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.first
      user ||= FactoryGirl.create(:user)
      sign_in user
    end
  end
end