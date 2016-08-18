require 'rails_helper'
describe UsersController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }
  let(:attributes) { attributes_for(:user) }
  describe "GET 'show'" do
    render_views false
    context 'when logged out' do
      before { get :show }
      subject { response }
      it { should redirect_to login_path }
    end
    context 'when logged in' do
      login_user
      context "when request is for the same user as is logged in" do
        before { get :show, id: attributes[:username], provider: attributes[:provider] }
        subject { response }
        it { should_not be_redirect }
        context "when not rendering views" do
          render_views false
          it { should be_success }
          it("should have a 200 status") { expect(subject.status).to be(200) }
          it("should assign @user") do
            expect(assigns(:user)).not_to be_nil
            expect(assigns(:user)).to be_a(User)
          end
        end
        context "when rendering views" do
          render_views
          it do
            should render_template("layouts/login")
            should render_template("users/show")
            should render_template("common/_alerts")
          end
        end
      end
      context "when request is for a different username than is logged in" do
        before { get :show, id: 'different', provider: attributes[:provider] }
        subject { response }
        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(user_url build(:user))}
      end
      context "when request is for a different provider than is logged in" do
        before { get :show, id: attributes[:username], provider: 'aleph' }
        subject { response }
        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(user_url build(:user))}
      end
    end
  end
  describe "OmniAuth callback methods" do
    describe "GET 'aleph'" do
      let(:auth_type) { 'bobst' }
      subject { get :aleph, { auth_type: auth_type }; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:aleph) }
        context 'when eshelf url and cookie are set' do
          before { stub_const('ENV', ENV.to_hash.merge('ESHELF_LOGIN_URL' => 'https://eshelf.library.edu')) }
          context 'when eshelf cookie is already set' do
            before { @request.cookies[:_nyulibraries_eshelf_passthru] = true }
            it { should redirect_to root_url }
          end
          it 'should set eshelf cookie' do
            expect(subject.cookies['_nyulibraries_eshelf_passthru']).to eql "1"
          end
          it { should redirect_to 'https://eshelf.library.edu' }
        end
        context 'when the omniauth.auth.provider is aleph' do
          context 'when the user doesn\'t exist' do
            let(:identity) { assigns(:user).identities.last }
            it "should assign an aleph user to @user"do
              subject
              expect(assigns(:user)).not_to be_nil
              expect(assigns(:user)).to be_a(User)
              expect(assigns(:user)).not_to be_a_new(User)
              expect(assigns(:user).provider).to eq("aleph")
              expect(assigns(:user).identities.count).to eq 1
              expect(identity).not_to be_nil
              expect(identity).to be_a(Identity)
              expect(identity.uid).not_to be_nil
              expect(identity.provider).to eq("aleph")
              expect(identity.properties).not_to be_nil
              expect(identity.properties).not_to be_empty
            end
            it { should be_redirect }
            it { should redirect_to root_url }
          end
          context "with existing, matching user" do
            let!(:existing_user){ create(:user, username: 'n19064851', provider: 'aleph') }
            it "should assign existing aleph user to @user"do
              subject
              expect(assigns(:user)).to eq existing_user
            end
            it { should be_redirect }
            it { should redirect_to root_url }
            context "with existing, matching identity" do
              let!(:existing_identity){ existing_user.identities.first }
              let(:identity) { assigns(:user).identities.last }
              it "should assign existing identity to @user.identity" do
                subject
                expect(identity).to eq existing_identity
              end
              context "if expired" do
                before do
                  existing_identity.update_attribute :updated_at, Time.now - 1.day - 1.hour
                  expect(existing_identity).to be_expired
                end
                it "should update" do
                  subject
                  expect(identity).to_not be_expired
                end
              end
              context "if unexpired" do
                let(:updated_at){ Time.now - 30.minutes }
                before do
                  existing_identity.update_attribute :updated_at, updated_at
                  expect(existing_identity).to_not be_expired
                end
                it "should not update" do
                  subject
                  expect(identity.updated_at).to eq updated_at
                end
              end
            end
          end
          context "with existing, non-matching user" do
            let!(:existing_user){ create(:user, username: 'xxxxxx', provider: 'aleph') }
            let(:identity) { assigns(:user).identities.last }
            it "should assign a new aleph user to @user"do
              subject
              expect(assigns(:user)).not_to be_nil
              expect(assigns(:user)).to be_a(User)
              expect(assigns(:user)).not_to be_a_new(User)
              expect(assigns(:user).provider).to eq("aleph")
              expect(identity).not_to be_nil
              expect(identity).to be_a(Identity)
              expect(identity.uid).not_to be_nil
              expect(identity.provider).to eq("aleph")
              expect(identity.properties).not_to be_nil
              expect(identity.properties).not_to be_empty
            end
            it { should be_redirect }
            it { should redirect_to root_url }
          end
        end
        context 'when the omniauth.auth environment provider is not aleph' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
        context 'when the omniauth.auth environment username is empty' do
          before { @request.env['omniauth.auth'].uid = "" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:user)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(auth_url(auth_type, 'nyu')) }
      end
    end

    describe "GET 'twitter'" do
      let(:auth_type) { 'twitter' }
      subject { get :twitter, { auth_type: auth_type }; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:twitter) }
        context 'when the omniauth.auth.provider is twitter' do
          let(:identity) { assigns(:user).identities.first }
          it "should assign a twitter user to @user" do
            subject
            expect(assigns(:user)).to be_a(User)
            expect(assigns(:user)).not_to be_nil
            expect(assigns(:user).provider).to eq("twitter")
            expect(identity).not_to be_nil
            expect(identity).to be_a(Identity)
            expect(identity.uid).not_to be_nil
            expect(identity.provider).to eq("twitter")
            expect(identity.properties).not_to be_nil
            expect(identity.properties).not_to be_empty
          end
          it { should be_redirect }
          it { should redirect_to root_url }
        end
        context 'when the omniauth.auth environment provider is not twitter' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
        context 'when the omniauth.auth environment username is empty' do
          before { @request.env['omniauth.auth'].info.nickname = "" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
     end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:user)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(auth_url(auth_type, 'nyu')) }
      end
    end

    describe "GET 'facebook'" do
      let(:auth_type) { 'facebook' }
      subject { get :facebook, { auth_type: auth_type }; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:facebook) }
        context 'when the omniauth.auth.provider is facebook' do
          let(:identity) { assigns(:user).identities.first }
          it "should assign a facebook user to @user" do
            subject
            expect(assigns(:user)).to be_a(User)
            expect(assigns(:user)).not_to be_nil
            expect(assigns(:user).provider).to eq("facebook")
            expect(identity).not_to be_nil
            expect(identity).to be_a(Identity)
            expect(identity.uid).not_to be_nil
            expect(identity.provider).to eq("facebook")
            expect(identity.properties).not_to be_nil
            expect(identity.properties).not_to be_empty
          end
          it { should be_redirect }
          it { should redirect_to root_url }
        end
        context 'when the omniauth.auth environment provider is not facebook' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
        context 'when the omniauth.auth environment username is empty' do
          before { @request.env['omniauth.auth'].info.nickname = "" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:user)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(auth_url(auth_type, 'nyu')) }
      end
    end

    describe "GET 'nyu_shibboleth'" do
      let(:auth_type) { 'nyu' }
      subject { get :nyu_shibboleth, { auth_type: auth_type }; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:nyu_shibboleth) }
        context 'when the omniauth.auth environment provider is not nyu_shibboleth' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
        context 'when the omniauth.auth environment username is empty' do
          before { @request.env['omniauth.auth'].uid = "" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:user)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(login_url('nyu')) }
      end
    end


    describe "GET 'new_school_ldap'" do
      let(:auth_type) { 'ns' }
      subject { get :new_school_ldap, { auth_type: auth_type }; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:new_school_ldap) }
        context 'when the omniauth.auth environment provider is not new_school_ldap' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
        context 'when the omniauth.auth environment username is empty' do
          before { @request.env['omniauth.auth'][:uid] = '' }
          it("should not assign @user") { expect(assigns(:user)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(auth_url(auth_type, 'nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:user)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(auth_url(auth_type, 'nyu')) }
      end
    end
  end

  describe 'GET /login/passive' do
    render_views false
    let(:client_id) { create(:oauth_application, redirect_uri: 'https://trustedapp.nyu.edu').uid }
    let(:return_uri) { 'https://trustedapp.nyu.edu/i/was/in/the/middle/of/something' }
    let(:login_path) { nil }
    let(:params) { { client_id: client_id, return_uri: return_uri, login_path: login_path } }
    let(:session_params) { nil }
    context 'when user is logged out' do
      before { get :client_passive_login, params, session_params }
      subject { response }
      context 'and hasnt made a call to Shibboleth Idp yet' do
        let(:escaped_return_uri) { "#{CGI::escape(return_uri)}" }
        let(:escaped_origin) { "#{CGI::escape("http://test.host/login/passive?client_id=#{client_id}&return_uri=#{escaped_return_uri}")}" }
        let(:target_url) { CGI::escape("http://test.host/login/passive_shibboleth?origin=#{escaped_origin}") }
        it { should redirect_to "http://test.host/Shibboleth.sso/Login?isPassive=true&target=#{target_url}" }
      end
      context 'and has already made a call to Shibboleth Idp' do
        let(:session_params) { {:_check_passive_shibboleth => true} }
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
      let(:origin) { CGI::escape('https://trustedapp.nyu.edu/i/was/in/the/middle/of/something') }
      before { get :client_passive_login, params, session_params }
      subject { response }
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
    subject { response }
    context 'when user is logged in to shibboleth' do
      before { get :shibboleth_passive_login, origin: origin }
      prepend_before { @request.cookies[:_shibsession_] = 'test123' }
      it { should redirect_to 'http://test.host/users/auth/nyu_shibboleth?auth_type=nyu&institute=NYU&origin=https%3A%2F%2Ftrustedapp.nyu.edu' }
    end
    context 'when user is not logged in to shibboleth' do
      before { get :shibboleth_passive_login, origin: origin }
      it { should redirect_to 'https://trustedapp.nyu.edu' }
    end
  end

  describe 'GET /passthru' do
    let(:params) { nil }
    let(:redirect_uri) { 'https://trustedapp.nyu.edu' }
    let(:session_params) { { _action_before_eshelf_redirect: redirect_uri } }
    before { get :passthru, params, session_params }
    prepend_before { @request.cookies[:_nyulibraries_eshelf_passthru] = { value: 1, httponly: true, domain: '.localhost' } }
    subject { response }
    context 'when user has a saved action in session' do
      it { should redirect_to 'https://trustedapp.nyu.edu' }
    end
    context 'when user has no saved action' do
      let(:redirect_uri) { nil }
      it { should redirect_to root_path }
    end
  end

  describe '#root_url_redirect' do
    login_user
    subject { @controller.send(:root_url_redirect) }
    context 'when BOBCAT_URL and PDS_URL environment variables are not set' do
      before { stub_const('ENV', ENV.to_hash.merge('BOBCAT_URL' => nil)) }
      before { stub_const('ENV', ENV.to_hash.merge('PDS_URL' => nil)) }
      it { should eql "https://pds.library.nyu.edu/pds?func=load-login&institute=NYU&calling_system=primo&url=http%3a%2f%2fbobcat.library.nyu.edu%2fprimo_library%2flibweb%2faction%2fsearch.do%3fdscnt%3d0%26amp%3bvid%3dNYU&func=load-login&amp;institute=NYU&amp;calling_system=primo&amp;url=http://bobcat.library.nyu.edu:80/primo_library/libweb/action/login.do" }
    end
  end
end
