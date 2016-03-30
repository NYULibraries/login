require 'rails_helper'
describe "routes for Wayf" do
  describe "GET /login" do
    context "when no institution is passed" do
      subject { get('/login') }
      it { should route_to({ controller: "wayf", action: "index" }) }
    end
    context "when institution is NYU is passed" do
      subject { get('/login/nyu') }
      it { should route_to({ controller: "wayf", action: "index", institution: "nyu" }) }
    end
    context "when institution is NS is passed" do
      subject { get('/login/ns') }
      it { should route_to({ controller: "wayf", action: "index", institution: "ns" }) }
    end
    context "when institution is CU is passed" do
      subject { get('/login/cu') }
      it { should route_to({ controller: "wayf", action: "index", institution: "cu" }) }
    end
    context "when institution is NYSID is passed" do
      subject { get('/login/nysid') }
      it { should route_to({ controller: "wayf", action: "index", institution: "nysid" }) }
    end
    context "when institution is NYUSH is passed" do
      subject { get('/login/nyush') }
      it { should route_to({ controller: "wayf", action: "index", institution: "nyush" }) }
    end
    context "when institution is NYUAD is passed" do
      subject { get('/login/nyuad') }
      it { should route_to({ controller: "wayf", action: "index", institution: "nyuad" }) }
    end
    context "when institution is HSL is passed" do
      subject { get('/login/hsl') }
      it { should route_to({ controller: "wayf", action: "index", institution: "hsl" }) }
    end
  end
end
