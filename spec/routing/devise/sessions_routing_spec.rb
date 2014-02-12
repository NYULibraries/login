require 'spec_helper'
describe "routes for Devise::Sessions" do
  describe "GET /login" do
    context "when no institute is passed" do
      subject { get('/login') }
      it { should route_to(controller: "devise/sessions", action: "new") }
    end

    context "when 'ns' is the institute parameter" do
      context "when it's a bound parameter" do
        subject { get('/login/ns') }
        it { should route_to(controller: "devise/sessions", action: "new", institute: "ns") }
      end

      context "when it's a query string parameter" do
        subject { get('/login?institute=ns') }
        it { should route_to(controller: "devise/sessions", action: "new", institute: "ns") }
      end
    end

    context "when 'invalid' institute is bound passed" do
      context "when it's a bound parameter" do
        subject { get('/login/invalid') }
        it { should route_to(controller: "devise/sessions", action: "new", institute: "invalid") }
      end

      context "when it's a query string parameter" do
        subject { get('/login?institute=invalid') }
        it { should route_to(controller: "devise/sessions", action: "new", institute: "invalid") }
      end
    end
  end

  describe "POST /login" do
    subject { post('/login') }
    it { should_not be_routable }
  end
end
