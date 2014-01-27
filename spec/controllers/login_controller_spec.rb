require 'spec_helper'
describe LoginController do
  context "when not logged in" do
    describe "GET 'new'" do
      before { get :new }
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
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU" do
      before { get :new, { institute: 'nyu' } }
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
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU Abu Dhabi" do
      before { get :new, { institute: 'nyuad' } }
      subject { response }
      context "when rendering views" do
        render_views
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU Shanghai" do
      before { get :new, { institute: 'nyush' } }
      subject { response }
      context "when rendering views" do
        render_views
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU Health Science Libraries" do
      before { get :new, { institute: 'hsl' } }
      subject { response }
      context "when rendering views" do
        render_views
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for the New School" do
      before { get :new, { institute: 'ns' } }
      subject { response }
      context "when rendering views" do
        render_views
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_ns_ldap")
        end
      end
    end

    describe "GET 'new' for Cooper Union" do
      before { get :new, { institute: 'cu' } }
      subject { response }
      context "when rendering views" do
        render_views
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_aleph")
        end
      end
    end

    describe "GET 'new' for NYSID" do
      before { get :new, { institute: 'nysid' } }
      subject { response }
      context "when rendering views" do
        render_views
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_aleph")
        end
      end
    end

    describe "GET 'new' for NYU Libraries' affiliates" do
      before { get :new, { institute: 'bobst' } }
      subject { response }
      context "when rendering views" do
        render_views
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_aleph")
        end
      end
    end
  end
  
  context 'when logged in' do
    login_user
    render_views false
    describe "GET 'new'" do
      before { get :new }
      subject { response }
      it { should be_redirect }
      it("should have a 302 status") { expect(subject.status).to be(302) }
      it { should redirect_to("/users/#{attributes_for(:user)[:username]}") }
    end
  end
end
