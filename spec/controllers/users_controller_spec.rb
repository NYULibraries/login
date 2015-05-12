require 'spec_helper'
describe UsersController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }
  let(:attributes) { attributes_for(:user) }
  describe "GET /login/passive" do
    context 'when passive shibboleth has already been checked' do
      before { @request.cookies["_check_passive_shibboleth"] = true }
      context 'when not logged in' do
        context 'and redirect_uri is valid and client_id is valid' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "https://somehost.com", client_id: "1" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("https://somehost.com") }
        end
        context 'and redirect_uri is invalid and client_id is valid' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "https://evilhost.com", client_id: "1" }
          subject { response }
          it { should be_bad_request }
          it("should have a 400 status") { expect(subject.status).to be(400) }
        end
        context 'and redirect_uri is invalid and client_id is invalid' do
          before { get "check_passive_and_sign_client_in", return_uri: "https://evilhost.com", client_id: "2" }
          subject { response }
          it { should be_bad_request }
          it("should have a 400 status") { expect(subject.status).to be(400) }
        end
        context 'and redirect_uri is valid and client_id is invalid' do
          before { get "check_passive_and_sign_client_in", return_uri: "https://somehost.com", client_id: "2" }
          subject { response }
          it { should be_bad_request }
          it("should have a 400 status") { expect(subject.status).to be(400) }
        end
      end
      context 'when logged in' do
        login_user
        context 'and client login path is provided' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "/1", client_id: "1", login_path: "/newlogin" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("https://somehost.com/newlogin") }
        end
        context 'and client login path is not provided' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "/1", client_id: "1" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("https://somehost.com/login") }
        end
      end
    end
    context 'when passive shibboleth has not already been checked' do
      context 'when not logged in' do
        context 'and redirect_uri is valid and client_id is valid' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "https://somehost.com", client_id: "1" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("/Shibboleth.sso/Login?isPassive=true&target=#{URI.escape(request.original_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}") }
        end
        context 'and redirect_uri is invalid and client_id is valid' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "https://evilhost.com", client_id: "1" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("/Shibboleth.sso/Login?isPassive=true&target=#{URI.escape(request.original_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}") }
        end
        context 'and redirect_uri is invalid and client_id is invalid' do
          before { get "check_passive_and_sign_client_in", return_uri: "https://evilhost.com", client_id: "2" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("/Shibboleth.sso/Login?isPassive=true&target=#{URI.escape(request.original_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}") }
        end
        context 'and redirect_uri is valid and client_id is invalid' do
          before { get "check_passive_and_sign_client_in", return_uri: "https://somehost.com", client_id: "2" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("/Shibboleth.sso/Login?isPassive=true&target=#{URI.escape(request.original_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}") }
        end
      end
      context 'when logged in' do
        login_user
        context 'and client login path is provided' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "/1", client_id: "1", login_path: "/newlogin" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("https://somehost.com/newlogin") }
        end
        context 'and client login path is not provided' do
          before { controller.stub(:whitelisted_client).and_return(Doorkeeper::Application.new(uid: 1, redirect_uri: "https://somehost.com/some_callback")) }
          before { get "check_passive_and_sign_client_in", return_uri: "/1", client_id: "1" }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("https://somehost.com/login") }
        end
      end
    end
  end
  describe "GET 'show'" do
    render_views false
    context 'when not logged in' do
      context "when Shibboleth session doesn't exist" do
        context 'when _check_passive_shibboleth cookie has not been set' do
          before { get :show, id: attributes[:username], provider: attributes[:provider] }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to("/Shibboleth.sso/Login?isPassive=true&target=#{URI.escape(request.original_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}") }
          it("should set _check_passive_shibboleth cookie") { expect(subject.cookies["_check_passive_shibboleth"]).to be_true }
        end
        context 'when _check_passive_shibboleth cookie has been set' do
          before { @request.cookies["_check_passive_shibboleth"] = true }
          before { get :show, id: attributes[:username], provider: attributes[:provider] }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to(login_url) }
        end
      end
      context "when Shibboleth session does exist" do
        before { @request.cookies["_shibsession_"] = true }
        context 'when _check_passive_shibboleth cookie has not been set' do
          before { get :show, id: attributes[:username], provider: attributes[:provider] }
          subject { response }
          it { should be_redirect }
          it("should have a 302 status") { expect(subject.status).to be(302) }
          it { should redirect_to(user_omniauth_authorize_path(:nyu_shibboleth, institute: "NYU", auth_type: :nyu, redirect_to: URI.escape(request.original_url, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")))) }
        end
      end
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
        context 'when the omniauth.auth.provider is aleph' do
          context 'when the user doesn\'t exist' do
            let(:identity) { assigns(:user).identities.first }
            it "should assign an aleph user to @user"do
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
            it "should set a logged in cookie to trigger sign off in other applications" do
              expect(response.cookies['_login_sso']).to eq('modified bar')
            end
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
          before { @request.env['omniauth.auth'][:uid] = [] }
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
end
