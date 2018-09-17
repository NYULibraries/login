require 'rails_helper'
describe Users::PassthruController do
  before do
    params.delete_if { |k, v| v.nil? }
    session_params.delete_if { |k, v| v.nil? }
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'GET /passthru' do
    subject { get :passthru, params: params, session: session_params }

    let(:params) { {} }
    let(:redirect_uri) { 'https://trustedapp.nyu.edu' }
    let(:session_params) { { _action_before_eshelf_redirect: redirect_uri } }

    prepend_before { @request.cookies[:_nyulibraries_eshelf_passthru] = { value: 1, httponly: true, domain: '.localhost' } }

    context 'when user has a saved action in session' do
      it { should redirect_to 'https://trustedapp.nyu.edu' }
    end
    
    context 'when user has no saved action' do
      let(:redirect_uri) { nil }

      it { should redirect_to root_path }
    end
  end
end
