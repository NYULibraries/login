require 'spec_helper'

describe SessionsController do

  context 'when logged in' do
    login_user
    render_views false
    before { @request.cookies['_login_sso'] = 'foobar' }
    describe "GET 'destroy'" do
      subject { get :destroy }
      it { should be_redirect }
      it("should have a 302 status") { expect(subject.status).to be(302) }
      it("should delete the login_sso cookie") do
        expect(subject.cookies['_login_sso']).to be_nil
      end
      context 'when logged in as an nyu shibboleth user' do
        let(:provider) { 'nyu_shibboleth' }
        it { should redirect_to(ENV['SHIBBOLETH_LOGOUT_URL']) }
      end
      context 'when logged in as a new school user' do
        let(:provider) { 'new_school_ldap' }
        it { should redirect_to(logged_out_url(:nyu)) }
      end
    end
  end

  describe '#destroy_sso_cookie!' do
    subject { @controller.send(:destroy_sso_cookie!) }
    context 'when cookie domain is in the environment' do
      before { stub_const('ENV', {'COOKIE_DOMAIN' => '.library.nyu.edu'}) }
      it { should be_nil }
    end
  end

end
