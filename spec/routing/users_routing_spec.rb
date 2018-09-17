require 'rails_helper'
describe "routes for Users" do
  describe "GET /" do
    subject { get('/') }
    it { should route_to('root#root') }
  end

  describe "POST /" do
    subject { post('/') }
    it { should_not be_routable }
  end

  describe "GET /login/passive" do
    subject { get('/login/passive') }
    it { should route_to('users/client_passive_login#client_passive_login') }
  end

  describe "GET /api/v1/user" do
    subject { get('/api/v1/user') }
    it { should route_to({ controller: "api/v1/users", action: "show", format: :json }) }
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

    # Make sure usernames can have dots
    describe "GET /users/#{provider}/user.name" do
      subject { get("/users/#{provider}/user.name") }
      it { should route_to(controller: "users", action: "show", provider: "#{provider}", id: "user.name") }
    end

    describe "POST /users#{provider}/user.name" do
      subject { post("/users#{provider}/user.name") }
      it { should_not be_routable }
    end

    describe "PUT /users#{provider}/user.name" do
      subject { post("/users#{provider}/user.name") }
      it { should_not be_routable }
    end

    describe "DELETE /users#{provider}/user.name" do
      subject { delete("/users#{provider}/user.name") }
      it { should_not be_routable }
    end
  end
end
