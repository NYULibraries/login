require 'rails_helper'
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
    describe "GET 'index'" do
      let(:institution) { nil }
      let(:params_institution) { nil }
      before { @request.cookies['institution_from_url'] = params_institution }
      before { get :index, { institution: institution } }
      subject { response }
      render_views
      describe "GET 'index' for NYU" do
        context 'when institution is passed in to the url' do
          let(:institution) { 'NYU' }
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
        context 'when institution is passed in via omniauth.params' do
          let(:params_institution) { 'NYU' }
          let(:institution) { nil }
          it { should be_redirect }
          it { should redirect_to '/login/nyu' }
        end
      end
      describe "GET 'index' for HSL" do
        context 'when institution is passed in to the url' do
          let(:institution) { 'HSL' }
          it { should be_success }
          it("should have a 200 status") { expect(subject.status).to be(200) }
          it do
            should render_template("layouts/login")
            should render_template("common/_alerts")
            should render_template("wayf/_hsl")
          end
        end
        context 'when institution is passed in via omniauth.params' do
          let(:params_institution) { 'HSL' }
          it { should be_redirect }
          it { should redirect_to '/login/hsl' }
        end
      end
      describe "GET 'index' for NYUAD" do
        context 'when institution is passed in to the url' do
          let(:institution) { 'NYUAD' }
          it { should be_success }
          it("should have a 200 status") { expect(subject.status).to be(200) }
          it do
            should render_template("layouts/login")
            should render_template("common/_alerts")
            should render_template("wayf/_nyuad")
          end
        end
        context 'when institution is passed in via omniauth.params' do
          let(:params_institution) { 'NYUAD' }
          it { should be_redirect }
          it { should redirect_to '/login/nyuad' }
        end
      end
      describe "GET 'index' for NYUSH" do
        context 'when institution is passed in to the url' do
          let(:institution) { 'NYUSH' }
          it { should be_success }
          it("should have a 200 status") { expect(subject.status).to be(200) }
          it do
            should render_template("layouts/login")
            should render_template("common/_alerts")
            should render_template("wayf/_nyush")
          end
        end
        context 'when institution is passed in via omniauth.params' do
          let(:params_institution) { 'NYUSH' }
          it { should be_redirect }
          it { should redirect_to '/login/nyush' }
        end
      end
      describe "GET 'index' for NS" do
        context 'when institution is passed in to the url' do
          let(:institution) { 'NS' }
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
        end
        context 'when institution is passed in via omniauth.params' do
          let(:params_institution) { 'NS' }
          it { should be_redirect }
          it { should redirect_to '/login/ns' }
        end
      end
      describe "GET 'index' for CU" do
        context 'when institution is passed in to the url' do
          let(:institution) { 'CU' }
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
        context 'when institution is passed in via omniauth.params' do
          let(:params_institution) { 'CU' }
          it { should be_redirect }
          it { should redirect_to '/login/cu' }
        end
      end
      describe "GET 'index' for NYSID" do
        context 'when institution is passed in to the url' do
          let(:institution) { 'nysid' }
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
        context 'when institution is passed in via omniauth.params' do
          let(:params_institution) { 'nysid' }
          it { should be_redirect }
          it { should redirect_to '/login/nysid' }
        end
      end
    end
  end
end
