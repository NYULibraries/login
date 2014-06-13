require 'spec_helper'
describe UsersController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }
  let(:attributes) { attributes_for(:user) }
  describe "GET 'show'" do
    context 'when not logged in' do
      render_views false
      before { get :show, id: attributes[:username], provider: attributes[:provider] }
      subject { response }
      it { should be_redirect }
      it("should have a 302 status") { expect(subject.status).to be(302) }
      it { should redirect_to(login_url) }
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
  describe "Doorkeeper protected API" do
    context "when the request doesn't have an access token" do
      context 'and not logged in' do
        before { get :api }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end
      context 'and logged in' do
        login_user
        before { get :api }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end
    end
    context "when the request has an access token" do
      context "and it's valid" do
        set_access_token
        before { get :api, access_token: access_token, format: :json }
        subject { response }
        it { should be_success }
        describe 'body' do
          subject { response.body }
            it("should be the resource owner in json") do
            expect(subject).to eq(resource_owner.to_json(include: :identities))
          end
        end
      end
      context "and it's expired" do
        set_expired_access_token
        before { get :api, access_token: expired_access_token, format: :json }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end
      context "and it has been revoked" do
        set_revoked_access_token
        before { get :api, access_token: revoked_access_token, format: :json }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end
    end
  end
  describe "OmniAuth callback methods" do
    describe "GET 'aleph'" do
      subject { get :aleph; response }
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
          end
        end
        context 'when the omniauth.auth environment provider is not aleph' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:identity)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:identity)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(login_url('nyu')) }
      end
    end

    describe "GET 'twitter'" do
      subject { get :twitter; response }
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
          it("should not assign @user") { expect(assigns(:identity)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:identity)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(login_url('nyu')) }
      end
    end

    describe "GET 'facebook'" do
      subject { get :facebook; response }
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
          it("should not assign @user") { expect(assigns(:identity)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:identity)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(login_url('nyu')) }
      end
    end

    describe "GET 'nyu_shibboleth'" do
      subject { get :nyu_shibboleth; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:nyu_shibboleth) }
        context 'when the omniauth.auth.provider is shibboleth_passive' do
          let(:identity) { assigns(:user).identities.first }
          it "should assign a nyu_shibboleth user to @user" do
            subject
            expect(assigns(:user)).to be_a(User)
            expect(assigns(:user)).not_to be_nil
            expect(assigns(:user).provider).to eq("nyu_shibboleth")
            expect(identity).not_to be_nil
            expect(identity).to be_a(Identity)
            expect(identity.uid).not_to be_nil
            expect(identity.provider).to eq("nyu_shibboleth")
            expect(identity.properties).not_to be_nil
            expect(identity.properties).not_to be_empty
          end
          it { should be_redirect }
          it { should redirect_to root_url }
        end
        context 'when the omniauth.auth environment provider is not nyu_shibboleth' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:identity)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:identity)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(login_url('nyu')) }
      end
    end


    describe "GET 'new_school_ldap'" do
      subject { get :new_school_ldap; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:new_school_ldap) }
        context 'when the omniauth.auth.provider is shibboleth_passive' do
          let(:identity) { assigns(:user).identities.first }
          it "should assign a nyu_shibboleth user to @user" do
            subject
            expect(assigns(:user)).to be_a(User)
            expect(assigns(:user)).not_to be_nil
            expect(assigns(:user).provider).to eq("new_school_ldap")
            expect(identity).not_to be_nil
            expect(identity).to be_a(Identity)
            expect(identity.uid).not_to be_nil
            expect(identity.provider).to eq("new_school_ldap")
            expect(identity.properties).not_to be_nil
            expect(identity.properties).not_to be_empty
          end
          it { should be_redirect }
          it { should redirect_to root_url }
        end
        context 'when the omniauth.auth environment provider is not new_school_ldap' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:identity)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:identity)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(login_url('nyu')) }
      end
    end

    describe "GET 'shibboleth_passive'" do
      subject { get :shibboleth_passive; response }
      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:shibboleth_passive) }
        context 'when the omniauth.auth.provider is shibboleth_passive' do
          let(:identity) { assigns(:user).identities.first }
          it "should assign a nyu_shibboleth user to @user" do
            subject
            expect(assigns(:user)).to be_a(User)
            expect(assigns(:user)).not_to be_nil
            expect(assigns(:user).provider).to eq("nyu_shibboleth")
            expect(identity).not_to be_nil
            expect(identity).to be_a(Identity)
            expect(identity.uid).not_to be_nil
            expect(identity.provider).to eq("nyu_shibboleth")
            expect(identity.properties).not_to be_nil
            expect(identity.properties).not_to be_empty
          end
          it { should be_redirect }
          it { should redirect_to root_url }
        end
        context 'when the omniauth.auth environment provider is not shibboleth_passive' do
          before { @request.env['omniauth.auth'].provider = "invalid" }
          it("should not assign @user") { expect(assigns(:identity)).to be_nil }
          it { should be_redirect }
          it { should redirect_to(login_url('nyu')) }
        end
      end
      context 'when the omniauth.auth environment is not present' do
        it("should not assign @user") { expect(assigns(:identity)).to be_nil }
        it { should be_redirect }
        it { should redirect_to(login_url('nyu')) }
      end
    end
  end
end
