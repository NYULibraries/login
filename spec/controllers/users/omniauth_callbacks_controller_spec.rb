require 'rails_helper'
describe Users::OmniauthCallbacksController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "OmniAuth callback methods" do
    describe "GET 'aleph'" do
      let(:auth_type) { 'bobst' }
      subject { get :aleph, params: { auth_type: auth_type } }

      context 'when the omniauth.auth environment is present' do
        before { @request.env['omniauth.auth'] = authhash(:aleph) }

        context 'when eshelf url and cookie are set' do
          before { stub_const('ENV', ENV.to_hash.merge('ESHELF_LOGIN_URL' => eshelf_login_url)) }

          let(:eshelf_login_url) { 'https://eshelf.library.edu' }

          context 'when eshelf cookie is already set' do
            before { @request.cookies[:_nyulibraries_eshelf_passthru] = true }

            it { should redirect_to root_url }
          end

          it 'should set eshelf cookie' do
            expect(subject.cookies['_nyulibraries_eshelf_passthru']).to eql "1"
          end
          it { should redirect_to eshelf_login_url }
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
            let!(:existing_user) do
              create(
                :user,
                username: (ENV["TEST_ALEPH_USER"] || 'BOR_ID').downcase,
                provider: 'aleph'
              )
            end

            it "should assign existing aleph user to @user" do
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

              it "should update" do
                subject
                expect(existing_identity.updated_at).to be < identity.updated_at
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
      subject { get :twitter, params: { auth_type: auth_type }; response }
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
      subject { get :facebook, params: { auth_type: auth_type }; response }
      let(:auth_type) { 'facebook' }

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
      subject { get :nyu_shibboleth, params: { auth_type: auth_type }; response }

      let(:auth_type) { 'nyu' }

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
      subject { get :new_school_ldap, params: { auth_type: auth_type }; response }
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
end
