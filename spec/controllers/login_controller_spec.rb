require 'spec_helper'

describe LoginController do
  
  context "when not logged in" do
    describe "GET 'new'" do
      context 'when not rendering views' do
        render_views false
        subject { get :new; response }
        it { should be_success }
        it("should have a 200 status") { expect(subject.status).to be(200) }
      end

      context "when rendering views" do
        render_views
        subject { get :new; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU" do
      context 'when not rendering views' do
        render_views false
        subject { get :new, { institute: 'nyu' }; response }
        it { should be_success }
        it("should have a 200 status") { expect(subject.status).to be(200) }
      end

      context "when rendering views" do
        render_views
        let(:get_new) { get :new, { institute: 'nyu' } }
        subject { get_new; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU Abu Dhabi" do
      context "when rendering views" do
        render_views
        subject { get :new, { institute: 'nyuad' }; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU Shanghai" do
      context "when rendering views" do
        render_views
        subject { get :new, { institute: 'nyush' }; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for NYU Health Science Libraries" do
      context "when rendering views" do
        render_views
        subject { get :new, { institute: 'hsl' }; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_nyu_shibboleth")
        end
      end
    end

    describe "GET 'new' for the New School" do
      context "when rendering views" do
        render_views
        subject { get :new, { institute: 'ns' }; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_ns_ldap")
        end
      end
    end

    describe "GET 'new' for Cooper Union" do
      context "when rendering views" do
        render_views
        subject { get :new, { institute: 'cu' }; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_aleph")
        end
      end
    end

    describe "GET 'new' for NYSID" do
      context "when rendering views" do
        render_views
        subject { get :new, { institute: 'nysid' }; response }
        it do
          should render_template("layouts/login")
          should render_template("login/new")
          should render_template("common/_alerts")
          should render_template("login/_aleph")
        end
      end
    end

    describe "GET 'new' for NYU Libraries' affiliates" do
      context "when rendering views" do
        render_views
        subject { get :new, { institute: 'bobst' }; response }
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
      subject { get :new; response }
      it { should be_redirect }
      it("should have a 302 status") { expect(subject.status).to be(302) }
    end
  end
end
