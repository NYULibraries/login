require 'rails_helper'
describe UsersController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:attributes) { attributes_for(:user) }

  describe "GET 'show'" do
    render_views false
    context 'when logged out' do
      subject { get :show }

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
        subject { get(:show, { params: { id: 'different', provider: attributes[:provider] } }) }

        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(user_url build(:user))}
      end
      context "when request is for a different provider than is logged in" do
        subject { get :show, params: { id: attributes[:username], provider: 'aleph' } }

        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to(user_url build(:user)) }
      end
    end
  end
end
