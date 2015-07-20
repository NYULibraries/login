require 'spec_helper'
module Devise
  describe SessionsController do
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }
    context "when not logged in" do
      describe "GET 'new' for NYU" do
        let(:auth_type) { 'bobst' }
        before { get :new, { institution: 'nyu', auth_type: auth_type } }
        subject { response }
        context 'when not rendering views' do
          render_views false
          it { should be_success }
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

      describe "GET 'new' for NYU Abu Dhabi" do
        let(:auth_type) { 'bobst' }
        before { get :new, { institution: 'nyuad', auth_type: auth_type } }
        subject { response }
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

      describe "GET 'new' for NYU Shanghai" do
        let(:auth_type) { 'bobst' }
        before { get :new, { institution: 'nyush', auth_type: auth_type } }
        subject { response }
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

      describe "GET 'new' for NYU Health Science Libraries" do
        let(:auth_type) { 'bobst' }
        before { get :new, { institution: 'hsl', auth_type: auth_type } }
        subject { response }
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

      describe "GET 'new' for the New School" do
        let(:auth_type) { 'ns' }
        before { get :new, { institution: 'ns', auth_type: auth_type } }
        subject { response }
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

      describe "GET 'new' for Cooper Union" do
        let(:auth_type) { 'cu' }
        before { get :new, { institution: 'cu', auth_type: auth_type } }
        subject { response }
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

      describe "GET 'new' for NYSID" do
        let(:auth_type) { 'nysid' }
        before { get :new, { institution: 'nysid', auth_type: auth_type } }
        subject { response }
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

    context 'when logged in' do
      login_user
      render_views false
      describe "GET 'new'" do
        before { get :new, { institution: 'nyu', auth_type: 'bobst' } }
        subject { response }
        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(root_url) }
      end
    end
  end
end
