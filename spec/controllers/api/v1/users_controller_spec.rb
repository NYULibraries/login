require 'spec_helper'

describe Api::V1::UsersController do

  describe 'GET #show' do

    context "when the request doesn't have an access token" do

      context 'and not logged in' do
        before { get :show }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

      context 'and logged in' do
        login_user
        before { get :show }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

    end

    context "when the request has an access token" do

      context "and it's expired" do
        set_expired_access_token
        before { get :show, access_token: expired_access_token, format: :json }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

      context "and it has been revoked" do
        set_revoked_access_token
        before { get :show, access_token: revoked_access_token, format: :json }
        subject { response }
        it { should_not be_success }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

      context "and it's valid" do
        set_access_token
        before { get :show, access_token: access_token, format: :json }
        subject { response }
        it { should be_success }

        describe 'body' do

          subject { response.body }

          context "and the user's identity provider is Aleph" do
            it "should be the resource owner in json" do
              expect(subject).to eq(resource_owner.to_json(include: :identities))
            end
          end

          context "and the user's identity provider is Twitter" do

          end

          context "and the user's identity provider is Facebook" do

          end

          context "and the user's identity provider is NYU Shibboleth" do

          end

          context "and the user's identity provider is New School LDAP" do

          end

        end

      end

    end

  end

end
