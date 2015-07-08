require 'spec_helper'
describe WayfController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  context 'when not logged in' do
    describe "GET 'index' for NYU" do
      before { get :index }
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
          should render_template("common/_alerts")
          should render_template("wayf/_nyu")
          should render_template("wayf/auth_squares/_bobst")
          should render_template("wayf/auth_squares/_cu")
          should render_template("wayf/auth_squares/_ns")
          should render_template("wayf/auth_squares/_nysid")
          should render_template("wayf/auth_squares/_visitor")
        end
      end
    end
    describe "GET 'index' for HSL" do
      before { get :index, { institution: "hsl" } }
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
          should render_template("common/_alerts")
          should render_template("wayf/_hsl")
        end
      end
    end
    describe "GET 'index' for NYUAD" do
      before { get :index, { institution: "nyuad" } }
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
          should render_template("common/_alerts")
          should render_template("wayf/_nyuad")
        end
      end
    end
    describe "GET 'index' for NYUSH" do
      before { get :index, { institution: "nyush" } }
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
          should render_template("common/_alerts")
          should render_template("wayf/_nyush")
        end
      end
    end
    describe "GET 'index' for NS" do
      before { get :index, { institution: "ns" } }
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
          should render_template("common/_alerts")
          should render_template("wayf/_ns")
          should render_template("wayf/auth_squares/_nyu")
          should render_template("wayf/auth_squares/_cu")
          should render_template("wayf/auth_squares/_nysid")
          should render_template("wayf/auth_squares/_visitor")
        end
      end
      describe "GET 'index' for CU" do
        before { get :index, { institution: "cu" } }
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
            should render_template("common/_alerts")
            should render_template("wayf/_cu")
            should render_template("wayf/auth_squares/_nyu")
            should render_template("wayf/auth_squares/_ns")
            should render_template("wayf/auth_squares/_nysid")
            should render_template("wayf/auth_squares/_visitor")
          end
        end
      end
      describe "GET 'index' for NYSID" do
        before { get :index, { institution: "nysid" } }
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
end
