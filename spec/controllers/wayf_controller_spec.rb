require 'spec_helper'
describe WayfController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  context 'when logged in' do
    login_user
    describe 'GET /logged_out' do
      before { get :logged_out }
      subject { response }
      it { should redirect_to logout_url }
    end
  end

  context 'when not logged in' do
    describe 'GET /logged_out' do
      render_views
      before { get :logged_out }
      subject { response }
      it { should render_template("wayf/logged_out") }
    end
    describe "GET 'index' for NYU" do
      before { get :index }
      subject { response }
      render_views
      it { should be_success }
      it("should have a 200 status") { expect(subject.status).to be(200) }
      it do
        should render_template("layouts/login")
        should render_template("common/_alerts")
        should render_template("wayf/_nyu")
        should render_template("wayf/auth_squares/_bobst")
        should render_template("wayf/auth_squares/_cu")
        should render_template("wayf/auth_squares/_ns")
        should render_template("wayf/auth_squares/_nysid")
        should render_template("wayf/auth_squares/_visitor")
      end
    end
    describe "GET 'index' for HSL" do
      before { get :index, { institution: "hsl" } }
      subject { response }
      render_views
      it { should be_success }
      it("should have a 200 status") { expect(subject.status).to be(200) }
      it do
        should render_template("layouts/login")
        should render_template("common/_alerts")
        should render_template("wayf/_hsl")
      end
    end
    describe "GET 'index' for NYUAD" do
      before { get :index, { institution: "nyuad" } }
      subject { response }
      render_views
      it { should be_success }
      it("should have a 200 status") { expect(subject.status).to be(200) }
      it do
        should render_template("layouts/login")
        should render_template("common/_alerts")
        should render_template("wayf/_nyuad")
      end
    end
    describe "GET 'index' for NYUSH" do
      before { get :index, { institution: "nyush" } }
      subject { response }
      render_views
      it { should be_success }
      it("should have a 200 status") { expect(subject.status).to be(200) }
      it do
        should render_template("layouts/login")
        should render_template("common/_alerts")
        should render_template("wayf/_nyush")
      end
    end
    describe "GET 'index' for NS" do
      before { get :index, { institution: "ns" } }
      subject { response }
      render_views
      it { should be_success }
      it("should have a 200 status") { expect(subject.status).to be(200) }
      it do
        should render_template("layouts/login")
        should render_template("common/_alerts")
        should render_template("wayf/_ns")
        should render_template("wayf/auth_squares/_nyu")
        should render_template("wayf/auth_squares/_cu")
        should render_template("wayf/auth_squares/_nysid")
        should render_template("wayf/auth_squares/_visitor")
      end
      describe "GET 'index' for CU" do
        before { get :index, { institution: "cu" } }
        subject { response }
        render_views
        it { should be_success }
        it("should have a 200 status") { expect(subject.status).to be(200) }
        it do
          should render_template("layouts/login")
          should render_template("common/_alerts")
          should render_template("wayf/_cu")
          should render_template("wayf/auth_squares/_nyu")
          should render_template("wayf/auth_squares/_ns")
          should render_template("wayf/auth_squares/_nysid")
          should render_template("wayf/auth_squares/_visitor")
        end
      end
      describe "GET 'index' for NYSID" do
        before { get :index, { institution: "nysid" } }
        subject { response }
        render_views
        it { should be_success }
        it("should have a 200 status") { expect(subject.status).to be(200) }
        it do
          should render_template("layouts/login")
          should render_template("common/_alerts")
          should render_template("wayf/_nysid")
          should render_template("wayf/auth_squares/_nyu")
          should render_template("wayf/auth_squares/_ns")
          should render_template("wayf/auth_squares/_cu")
          should render_template("wayf/auth_squares/_visitor")
        end
      end
    end
  end
end
