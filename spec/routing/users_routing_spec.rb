describe "routes for Login" do
  describe "GET /users" do
    subject { get('/users') }
    it { should_not be_routable }
  end

  describe "POST /users" do
    subject { post('/users') }
    it { should_not be_routable }
  end

  describe "PUT /users" do
    subject { post('/users') }
    it { should_not be_routable }
  end

  describe "DELETE /users" do
    subject { delete('/users') }
    it { should_not be_routable }
  end

  describe "GET /users/username" do
    subject { get('/users/username') }
    it { should route_to(controller: "users", action: "show", id: "username") }
  end

  describe "POST /users/username" do
    subject { post('/users/username') }
    it { should_not be_routable }
  end

  describe "PUT /users/username" do
    subject { post('/users/username') }
    it { should_not be_routable }
  end

  describe "DELETE /users/username" do
    subject { delete('/users/username') }
    it { should_not be_routable }
  end
end
