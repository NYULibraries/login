module LoginMacros
  def login_user
    let(:passthru_provider) { defined?(provider) ? provider : "twitter" }
    let(:user) { find_or_create_user_by_provider(passthru_provider) }
    before(:each) do |example|
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end

  def login_admin
    before(:each) do |example|
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in find_or_create_admin
    end
  end
end
