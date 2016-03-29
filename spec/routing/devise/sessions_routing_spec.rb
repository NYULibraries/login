require 'rails_helper'
describe "routes for Devise::Sessions" do
  describe "GET /auth" do
    context "when no auth_type is passed" do
      subject { get('/auth') }
      it { should_not be_routable }
    end

    context "when 'ns' is the auth_type parameter" do
      context "when it's a bound parameter" do
        subject { get('/auth/ns') }
        it { should route_to(controller: "devise/sessions", action: "new", auth_type: "ns") }
        context "and institue is a bound parameter" do
          subject { get('/auth/ns/ns') }
          it { should route_to(controller: "devise/sessions", action: "new", auth_type: "ns", institution: "ns") }
        end
        context "and institution a query string parameter" do
          subject { get('/auth/ns?institution=ns') }
          it { should route_to(controller: "devise/sessions", action: "new", auth_type: "ns", institution: "ns") }
        end
      end
      context "when it's querystring parameter" do
        subject { get('/auth?auth_type=ns') }
        it { should_not be_routable }
      end
    end

    context "when 'invalid' auth_type is bound parameter" do
      context "when it's a bound parameter" do
        subject { get('/auth/invalid') }
        it { should route_to(controller: "devise/sessions", action: "new", auth_type: "invalid") }
      end

      context "when it's a query string parameter" do
        subject { get('/auth?auth_type=invalid') }
        it { should_not be_routable }
      end
    end
  end

  describe "POST /auth" do
    subject { post('/auth') }
    it { should_not be_routable }
  end
end
