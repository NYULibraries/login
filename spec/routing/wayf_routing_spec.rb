require 'spec_helper'
describe "routes for Wayf" do
  describe "GET /login" do
    context "when no institution is passed" do
      subject { get('/login') }
      it { should route_to({ controller: "wayf", action: "index" }) }
    end
    context "when institute is NYU is passed" do
      subject { get('/login/nyu') }
      it { should route_to({ controller: "wayf", action: "index", institute: "nyu" }) }
    end
    context "when institute is NS is passed" do
      subject { get('/login/ns') }
      it { should route_to({ controller: "wayf", action: "index", institute: "ns" }) }
    end
    context "when institute is CU is passed" do
      subject { get('/login/cu') }
      it { should route_to({ controller: "wayf", action: "index", institute: "cu" }) }
    end
    context "when institute is NYSID is passed" do
      subject { get('/login/nysid') }
      it { should route_to({ controller: "wayf", action: "index", institute: "nysid" }) }
    end
    context "when institute is NYUSH is passed" do
      subject { get('/login/nyush') }
      it { should route_to({ controller: "wayf", action: "index", institute: "nyush" }) }
    end
    context "when institute is NYUAD is passed" do
      subject { get('/login/nyuad') }
      it { should route_to({ controller: "wayf", action: "index", institute: "nyuad" }) }
    end
    context "when institute is HSL is passed" do
      subject { get('/login/hsl') }
      it { should route_to({ controller: "wayf", action: "index", institute: "hsl" }) }
    end
  end
end
