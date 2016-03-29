require 'rails_helper'
module Doorkeeper
  describe AuthorizedApplicationsController do
    set_access_token
    let(:application) { oauth_application }
    context "when not logged in" do
      describe "GET 'index'" do
        before { get :index }
        subject { response }
        it { should be_redirect }
        it { should redirect_to(root_url) }
      end
      describe "DELETE 'destroy'" do
        before { delete :destroy, id: application.id }
        subject { response }
        it { should be_redirect }
        it { should redirect_to(root_url) }
      end
    end
    context "when logged in" do
      login_user
      describe "GET 'index'" do
        before { get :index }
        subject { response }
        it { should be_succes }
        it { should render_template(:index) }
      end
      describe "DELETE 'destroy'" do
        before { delete :destroy, id: application.id }
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/oauth/authorized_applications') }
      end
    end
  end
end
