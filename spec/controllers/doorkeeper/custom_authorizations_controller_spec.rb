require 'spec_helper'
module Doorkeeper
  describe CustomAuthorizationsController do
    let(:application) { create(:oauth_application) }
    let(:institution) { nil }
    let(:umlaut_institution) { nil }
    let(:params) { { client_id: application.uid,
      redirect_uri: application.redirect_uri, response_type: "code",
      institution: institution, "umlaut.institution" => umlaut_institution } }
    context "when not logged in" do
      describe "GET 'show'" do
        set_code
        before { get :show, code: code }
        subject { response }
        it { should be_redirect }
        it { should redirect_to(root_url) }
      end
      describe "GET 'new'" do
        before { get :new, params }
        subject { response }
        it { should be_redirect }
        it { should redirect_to(root_url) }
        context 'when no institution is set' do
          it { expect(cookies[:institution_from_url]).to be_nil }
        end
        context 'when umlaut.institution param is set' do
          let(:umlaut_institution) { 'NS' }
          it { expect(cookies[:institution_from_url]).to eql 'NS' }
        end
        context 'when institution param is set' do
          let(:institution) { 'CU' }
          it { expect(cookies[:institution_from_url]).to eql 'CU' }
        end
      end
      describe "POST 'create'" do
        before { post :create, params }
        subject { response }
        it { should be_redirect }
        it { should redirect_to(root_url) }
      end
      describe "DELETE 'destroy'" do
        before { delete :destroy, params }
        subject { response }
        it { should be_redirect }
        it { should redirect_to(root_url) }
      end
    end
    context "when logged in" do
      login_user
      describe "GET 'show'" do
        set_code
        before { get :show, code: code }
        subject { response }
        it { should be_succes }
        it { should render_template(:show) }
      end
      describe "GET 'new'" do
        before { get :new, params }
        subject { response }
        it { should be_redirect }
        it("should redirect to the callback URL") do
          expect(response.location).to start_with(application.redirect_uri+"?code=")
        end
      end
      describe "POST 'create'" do
        before { post :create, params }
        subject { response }
        it { should be_redirect }
        it("should redirect to the callback URL") do
          expect(response.location).to start_with(application.redirect_uri+"?code=")
        end
      end
      describe "DELETE 'destroy'" do
        before { delete :destroy, params }
        subject { response }
        it { should be_redirect }
        it { should redirect_to(application.redirect_uri +
          "?error=access_denied&error_description=The+resource+owner+or+authorization+server+denied+the+request.") }
      end
    end
  end
end
