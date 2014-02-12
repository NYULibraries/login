require 'spec_helper'
module Doorkeeper
  describe ApplicationsController do
    let(:application) { create(:oauth_application) }
    context "when not logged in" do
      describe "GET 'index'" do
        before { get :index }
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/login') }
      end
      describe "GET 'show'" do
        before { get :show, id: application.id }
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/login') }
      end
      describe "GET 'new'" do
        before { get :new }
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/login') }
      end
      describe "POST 'create'" do
        before { post :create, application: attributes_for(:oauth_application) }
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/login') }
      end
      describe "GET 'edit'" do
        before { get :show, id: application.id }
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/login') }
      end
      describe "PUT 'update'" do
        before do
          put :update, id: application.id, application: { name: "#{application.name} redux" }
        end
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/login') }
      end
      describe "DELETE 'destroy'" do
        before { delete :destroy, id: application.id }
        subject { response }
        it { should be_redirect }
        it { should redirect_to('/login') }
      end
    end
    context "when logged in" do
      context "and the user is not an admin" do
        login_user
        describe "GET 'index'" do
          before { get :index }
          subject { response }
          it { should be_redirect }
          it { should redirect_to(user_url(user.provider, user.username)) }
        end
        describe "GET 'show'" do
          before { get :show, id: application.id }
          subject { response }
          it { should be_redirect }
          it { should redirect_to(user_url(user.provider, user.username)) }
        end
        describe "GET 'new'" do
          before { get :new }
          subject { response }
          it { should be_redirect }
          it { should redirect_to(user_url(user.provider, user.username)) }
        end
        describe "POST 'create'" do
          before { post :create, application: attributes_for(:oauth_application) }
          subject { response }
          it { should be_redirect }
          it { should redirect_to(user_url(user.provider, user.username)) }
        end
        describe "GET 'edit'" do
          before { get :edit, id: application.id }
          subject { response }
          it { should be_redirect }
          it { should redirect_to(user_url(user.provider, user.username)) }
        end
        describe "PUT 'update'" do
          before do
            put :update, id: application.id, application: { name: "#{application.name} redux" }
          end
          subject { response }
          it { should be_redirect }
          it { should redirect_to(user_url(user.provider, user.username)) }
        end
        describe "DELETE 'destroy'" do
          before { delete :destroy, id: application.id }
          subject { response }
          it { should be_redirect }
          it { should redirect_to(user_url(user.provider, user.username)) }
        end
      end
      context "and the user is an admin" do
        login_admin
        describe "GET 'index'" do
          before { get :index }
          subject { response }
          it { should be_success }
        end
        describe "GET 'show'" do
          before { get :show, id: application.id }
          subject { response }
          it { should be_success }
        end
        describe "GET 'new'" do
          before { get :new }
          subject { response }
          it { should be_success }
        end
        describe "POST 'create'" do
          before { post :create, application: attributes_for(:oauth_application) }
          subject { response }
          it("should assign @application") do
            expect(assigns(:application)).not_to be_nil
            expect(assigns(:application)).to be_a(Doorkeeper::Application)
          end
          it { should be_redirect }
          it { should redirect_to(oauth_application_url(assigns(:application))) }
        end
        describe "GET 'edit'" do
          before { get :edit, id: application.id }
          subject { response }
          it { should be_success }
        end
        describe "PUT 'update'" do
          before do
            put :update, id: application.id, application: { name: "#{application.name} redux" }
          end
          subject { response }
          it("should assign @application") do
            expect(assigns(:application)).not_to be_nil
            expect(assigns(:application)).to be_a(Doorkeeper::Application)
            expect(assigns(:application)).not_to be(application)
          end
          it { should be_redirect }
          it { should redirect_to(oauth_application_url(assigns(:application))) }
        end
        describe "DELETE 'destroy'" do
          before { delete :destroy, id: application.id }
          subject { response }
          it("should assign @application") do
            expect(assigns(:application)).not_to be_nil
            expect(assigns(:application)).to be_a(Doorkeeper::Application)
            expect(assigns(:application)).not_to be(application)
          end
          it { should be_redirect }
          it { should redirect_to(oauth_applications_url) }
        end
      end
    end
  end
end
