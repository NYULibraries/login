require 'rails_helper'
module Users
  describe SessionsController do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'when not logged in' do
      describe "GET 'new'" do
        let(:auth_type) { 'bobst' }
        let(:institution) { nil }
        before { get :new, params: { institution: institution, auth_type: auth_type } }
        subject { response }

        describe 'for NYU' do
          let(:institution) { 'nyu' }

          context 'when not rendering views' do
            render_views false
            it { should be_successful }
            it("should have a 200 status") { expect(subject.status).to be(200) }
          end
          context "when rendering views" do
            render_views
            it do
              should render_template("layouts/login")
              should render_template("sessions/new")
              should render_template("common/_alerts")
            end
            context "when auth type is bobst" do
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is nysid" do
              let(:auth_type) { 'nysid' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is cooper union" do
              let(:auth_type) { 'cu' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is new school" do
              let(:auth_type) { 'ns' }
              it { should render_template("sessions/_new_school_ldap") }
            end
            context "when auth type is new school" do
              let(:auth_type) { 'visitor' }
              it { should render_template("sessions/_visitor") }
            end
          end
        end

        describe "for NYU Abu Dhabi" do
          let(:institution) { 'nyuad' }
          context "when rendering views" do
            render_views
            it do
              should render_template("layouts/login")
              should render_template("sessions/new")
              should render_template("common/_alerts")
            end
            context "when auth type is bobst" do
              it { should render_template("sessions/_aleph") }
            end
          end
        end

        describe "for NYU Shanghai" do
          let(:institution) { 'nyush' }
          context "when rendering views" do
            render_views
            it do
              should render_template("layouts/login")
              should render_template("sessions/new")
              should render_template("common/_alerts")
            end
            context "when auth type is bobst" do
              it { should render_template("sessions/_aleph") }
            end
          end
        end

        describe 'for NYU Health Science Libraries' do
          let(:institution) { 'hsl' }
          context "when rendering views" do
            render_views
            it do
              should render_template("layouts/login")
              should render_template("sessions/new")
              should render_template("common/_alerts")
            end
            context "when auth type is bobst" do
              it { should render_template("sessions/_aleph") }
            end
          end
        end

        describe "for the New School" do
          let(:auth_type) { 'ns' }
          let(:institution) { 'ns' }
          context "when rendering views" do
            render_views
            it do
              should render_template("layouts/login")
              should render_template("sessions/new")
              should render_template("common/_alerts")
            end
            context "when auth type is new school" do
              let(:auth_type) { 'ns' }
              it { should render_template("sessions/_new_school_ldap") }
            end
            context "when auth type is nysid" do
              let(:auth_type) { 'nysid' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is cooper union" do
              let(:auth_type) { 'cu' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is new school" do
              let(:auth_type) { 'visitor' }
              it { should render_template("sessions/_visitor") }
            end
          end
        end

        describe "for Cooper Union" do
          let(:auth_type) { 'cu' }
          let(:institution) { 'cu' }

          context "when rendering views" do
            render_views
            it do
              should render_template("layouts/login")
              should render_template("sessions/new")
              should render_template("common/_alerts")
            end
            context "when auth type is cooper union" do
              let(:auth_type) { 'cu' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is nysid" do
              let(:auth_type) { 'nysid' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is new school" do
              let(:auth_type) { 'ns' }
              it { should render_template("sessions/_new_school_ldap") }
            end
            context "when auth type is new school" do
              let(:auth_type) { 'visitor' }
              it { should render_template("sessions/_visitor") }
            end
          end
        end

        describe "for NYSID" do
          let(:auth_type) { 'nysid' }
          let(:institution) { 'nysid' }

          context "when rendering views" do
            render_views
            it do
              should render_template("layouts/login")
              should render_template("sessions/new")
              should render_template("common/_alerts")
            end
            context "when auth type is nysid" do
              let(:auth_type) { 'nysid' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is cooper union" do
              let(:auth_type) { 'cu' }
              it { should render_template("sessions/_aleph") }
            end
            context "when auth type is new school" do
              let(:auth_type) { 'ns' }
              it { should render_template("sessions/_new_school_ldap") }
            end
            context "when auth type is new school" do
              let(:auth_type) { 'visitor' }
              it { should render_template("sessions/_visitor") }
            end
          end
        end
      end
    end

    context 'when logged in' do
      login_user
      render_views false
      before do
        @request.cookies['_login_sso'] = 'foobar'
        @request.cookies['PDS_HANDLE'] = 'TEST123'
      end
      describe "DELETE 'destroy'" do
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
        it "should set post logout session variables so we know where to redirect" do
          expect(request.cookies[:provider]).to be_nil
          expect(request.cookies[:current_institution]).to be_nil
        end
      end

      describe "GET 'new'" do
        before { get :new, params: { institution: 'nyu', auth_type: 'bobst' } }
        subject { response }
        it { should be_redirect }
        its(:status) { is_expected.to be 302 }
        it { should redirect_to(root_url) }
      end
    end

  end
end
