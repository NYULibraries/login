describe "routes for Users" do
  describe "GET /" do
    subject { get('/') }
    it { should route_to('users#show') }
  end

  describe "POST /" do
    subject { post('/') }
    it { should_not be_routable }
  end

  NON_ROUTABLES =
    %w{ / /invalid_provider/username /aleph /twitter /facebook /omniauth_callback }
  # Non-routable
  NON_ROUTABLES.each do |path|
    describe "GET /users#{path}" do
      subject { get("/users") }
      it { should_not be_routable }
    end

    describe "POST /users#{path}" do
      subject { post("/users#{path}") }
      it { should_not be_routable }
    end

    describe "PUT /users#{path}" do
      subject { post("/users#{path}") }
      it { should_not be_routable }
    end

    describe "DELETE /users#{path}" do
      subject { delete("/users#{path}") }
      it { should_not be_routable }
    end
  end

  Devise.omniauth_providers.each do |provider|
    describe "GET /users/#{provider}/username" do
      subject { get("/users/#{provider}/username") }
      it { should route_to(controller: "users", action: "show", provider: "#{provider}", id: "username") }
    end

    describe "POST /users#{provider}/username" do
      subject { post("/users#{provider}/username") }
      it { should_not be_routable }
    end

    describe "PUT /users#{provider}/username" do
      subject { post("/users#{provider}/username") }
      it { should_not be_routable }
    end

    describe "DELETE /users#{provider}/username" do
      subject { delete("/users#{provider}/username") }
      it { should_not be_routable }
    end
  end
end
