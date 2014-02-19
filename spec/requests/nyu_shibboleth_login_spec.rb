require 'spec_helper'
describe "NYU Shibboleth Login" do
  before { https! }
  context "when there is no Shibboleth session in the SP " do
    it("should not have an OmniAuth AuthHash after running") do
      expect(@request).to be_nil
      get "/users/auth/nyu_shibboleth/callback"
      expect(@request.env['omniauth.auth']).to be_nil
    end
  end
  context "when there is a Shibboleth session in the SP " do
    it("should have an OmniAuth AuthHash after running") do
      expect(@request).to be_nil
      https!
      get "/users/auth/nyu_shibboleth/callback", nil, shibboleth_env
      expect(@request.env['omniauth.auth']).not_to be_nil
      expect(@request.env['omniauth.auth'].uid).not_to be_nil
      expect(@request.env['omniauth.auth'].uid).to eq('dev1')
      expect(@request.env['omniauth.auth'].info.name).not_to be_nil
      expect(@request.env['omniauth.auth'].info.name).to eq('Dev Eloper')
      expect(@request.env['omniauth.auth'].info.email).not_to be_nil
      expect(@request.env['omniauth.auth'].info.email).to eq('dev.eloper@nyu.edu')
      expect(@request.env['omniauth.auth'].info.nickname).not_to be_nil
      expect(@request.env['omniauth.auth'].info.nickname).to eq('Dev')
      expect(@request.env['omniauth.auth'].info.first_name).not_to be_nil
      expect(@request.env['omniauth.auth'].info.first_name).to eq('Dev')
      expect(@request.env['omniauth.auth'].info.last_name).not_to be_nil
      expect(@request.env['omniauth.auth'].info.last_name).to eq('Eloper')
      expect(@request.env['omniauth.auth'].extra.raw_info.nyuidn).not_to be_nil
      expect(@request.env['omniauth.auth'].extra.raw_info.nyuidn).to eq('1234567890')
      expect(@request.env['omniauth.auth'].extra.raw_info.entitlement).not_to be_nil
      expect(@request.env['omniauth.auth'].extra.raw_info.entitlement).to eq('urn:mace:nyu.edu:entl:lib:eresources;urn:mace:incommon:entitlement:common:1')
    end
  end
end
