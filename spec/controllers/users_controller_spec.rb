require 'spec_helper'

describe UsersController do
  describe "GET 'show'" do
    context 'when not logged in' do
      render_views false
      before { get :show, id: attributes_for(:user)[:username] }
      subject { response }
      it { should be_redirect }
      it("should have a 302 status") { expect(subject.status).to be(302) }
      it { should redirect_to('/login') }
    end
    context 'when logged in' do
      login_user
      context "when request is for the same user as is logged in" do
        before { get :show, id: attributes_for(:user)[:username] }
        subject { response }
        context "when not rendering views" do
          render_views false
          it { should be_success }
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
      context "when request is for a different user than is logged in" do
        before { get :show, id: 'different' }
        subject { response }
        it { should be_redirect }
        it("should have a 302 status") { expect(subject.status).to be(302) }
        it { should redirect_to('/login')}
      end
    end
  end
end
