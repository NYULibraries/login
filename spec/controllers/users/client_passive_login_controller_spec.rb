require 'rails_helper'
describe Users::ClientPassiveLoginController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET /login/passive' do
    render_views false
    let(:client_id) { create(:oauth_application, redirect_uri: 'https://trustedapp.nyu.edu').uid }
    let(:return_uri) { 'https://trustedapp.nyu.edu/i/was/in/the/middle/of/something' }
    let(:login_path) { nil }
    let(:params) { { client_id: client_id, return_uri: return_uri, login_path: login_path } }
    let(:session_params) { {} }

    before { params.delete_if { |k, v| v.nil? } }

    context 'when user is logged out' do
      subject { get :client_passive_login, params: params, session: session_params }

      context 'and hasnt made a call to Shibboleth Idp yet' do
        let(:escaped_return_uri) { "#{CGI::escape(return_uri)}" }
        let(:escaped_origin) { "#{CGI::escape("http://test.host/login/passive?client_id=#{client_id}&return_uri=#{escaped_return_uri}")}" }
        let(:target_url) { CGI::escape("http://test.host/login/passive_shibboleth?origin=#{escaped_origin}") }

        it { should redirect_to "http://test.host/Shibboleth.sso/Login?isPassive=true&target=#{target_url}" }
      end

      context 'and has already made a call to Shibboleth Idp' do
        let(:session_params) { { _check_passive_shibboleth: true } }

        context 'and the return uri is whitelisted' do
          it { should redirect_to 'https://trustedapp.nyu.edu/i/was/in/the/middle/of/something' }
        end

        context 'but the return uri is not whitelisted or mismatches the client return url' do
          let(:client_id) { create(:oauth_application) }
          let(:return_uri) { 'madeuphost.bg' }

          its(:status) { should be 400 }
        end
      end
    end

    context 'when user is logged in' do
      login_user
      subject { get :client_passive_login, params: params, session: session_params }

      let(:origin) { CGI::escape('https://trustedapp.nyu.edu/i/was/in/the/middle/of/something') }

      context 'and a custom login path is set' do
        let(:login_path) { '/login' }

        it { should redirect_to "https://trustedapp.nyu.edu/login?origin=#{origin}" }
      end

      context 'and no login path is set' do
        it { should redirect_to "https://trustedapp.nyu.edu/users/auth/nyulibraries?origin=#{origin}" }
      end
    end
  end

  describe 'GET /login/passive_shibboleth' do
    let(:origin) { 'https://trustedapp.nyu.edu' }

    context 'when user is logged in to shibboleth' do
      subject { get(:shibboleth_passive_login, params: { origin: origin }) }

      prepend_before { @request.cookies[:_shibsession_] = 'test123' }

      it { should redirect_to 'http://test.host/users/auth/nyu_shibboleth?auth_type=nyu&institute=NYU&origin=https%3A%2F%2Ftrustedapp.nyu.edu' }
    end

    context 'when user is not logged in to shibboleth' do
      before { get(:shibboleth_passive_login, params: { origin: origin }) }

      it { should redirect_to 'https://trustedapp.nyu.edu' }
    end
  end

end
