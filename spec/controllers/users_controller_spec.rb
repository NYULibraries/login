require 'rails_helper'
describe UsersController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }
  let(:attributes) { attributes_for(:user) }
  describe "GET 'show'" do
    render_views false
    context 'when logged out' do
      subject { response }

      before { get :show }

      it { should be_successful }
      its(:status) { is_expected.to eql 200 }
      it { should render_template "wayf/index" }
    end
    context 'when logged in' do
      login_user
      context "when request is for the same user as is logged in" do
        before { get :show, params: { id: attributes[:username], provider: attributes[:provider] } }
        subject { response }
        it { should_not be_redirect }
        context "when not rendering views" do
          it { should be_successful }
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
        before { get(:show, { params: { id: 'different', provider: attributes[:provider] } }) }
        subject { response }
        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(user_url build(:user))}
      end
      context "when request is for a different provider than is logged in" do
        before { get :show, params: { id: attributes[:username], provider: 'aleph' } }
        subject { response }
        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(user_url build(:user)) }
      end
    end
  end

  describe 'GET /passthru' do
    let(:params) { Hash.new }
    let(:redirect_uri) { 'https://trustedapp.nyu.edu' }
    let(:session_params) { { _action_before_eshelf_redirect: redirect_uri } }

    before { get :passthru, params: params, session: session_params }
    prepend_before { @request.cookies[:_nyulibraries_eshelf_passthru] = { value: 1, httponly: true, domain: '.localhost' } }
    subject { response }
    context 'when user has a saved action in session' do
      it { should redirect_to 'https://trustedapp.nyu.edu' }
    end
    context 'when user has no saved action' do
      let(:redirect_uri) { nil }
      it { should redirect_to root_path }
    end
  end

  describe '#root_url_redirect' do
    login_user
    subject { @controller.send(:root_url_redirect) }
    context 'when BOBCAT_URL and PDS_URL environment variables are not set' do
      before { stub_const('ENV', ENV.to_hash.merge('BOBCAT_URL' => nil)) }
      before { stub_const('ENV', ENV.to_hash.merge('PDS_URL' => nil)) }
      it { should eql "https://pds.library.nyu.edu/pds?func=load-login&institute=NYU&calling_system=primo&url=http%3a%2f%2fbobcat.library.nyu.edu%2fprimo_library%2flibweb%2faction%2fsearch.do%3fdscnt%3d0%26amp%3bvid%3dNYU&func=load-login&amp;institute=NYU&amp;calling_system=primo&amp;url=http://bobcat.library.nyu.edu:80/primo_library/libweb/action/login.do" }
    end
  end
end
