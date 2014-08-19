require 'spec_helper'

describe Api::V1::UsersController do

  let(:identity) { provider }

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
          subject(:body) { response.body }
          let(:identity_index) do
            parse_json(body)["identities"].find_index do |json_identity|
              json_identity["provider"].eql?(identity)
            end
          end

          context "and the user's identity provider is Aleph" do
            let(:provider) { "aleph" }
            let(:index) do
              parse_json(body)["identities"].find_index do |identity|
                identity["provider"].eql?(provider)
              end
            end

            it { should have_json_path("identities/#{index}/properties/uid") }
            it { should have_json_path("identities/#{index}/properties/extra/plif_status") }
            it { should have_json_path("identities/#{index}/properties/extra/patron_type") }
            it { should have_json_path("identities/#{index}/properties/extra/patron_status") }
            it { should have_json_path("identities/#{index}/properties/extra/ill_permission") }

            describe "identity properties" do
              let(:response_properties) { parse_json(body)["identities"][index]["properties"]  }
              subject { response_properties[property] }


              context "when property is the Aleph ID" do
                let(:property) { "uid" }
                it { should eql "N00000000" }
              end

              context "when the property is the extra attributes" do
                let(:property) { "extra" }
                its(["plif_status"])     { should eql "Kings Landing" }
                its(["patron_type"])     { should eql "Bastard" }
                its(["patron_status"])   { should eql "Night's Watch" }
                its(["ill_permission"])  { should eql "Y" }
              end

            end

          end

          context "and the user's identity provider is NYU Shibboleth" do
            let(:provider) { "nyu_shibboleth" }

            it { should have_json_path("identities/#{identity_index}/properties/uid") }
            it { should have_json_path("identities/#{identity_index}/properties/nyuidn") }
            it { should have_json_path("identities/#{identity_index}/properties/first_name") }
            it { should have_json_path("identities/#{identity_index}/properties/last_name") }
            it { should have_json_path("identities/#{identity_index}/properties/extra/entitlement") }

            let(:response_properties) { JSON.parse(response.body)["identities"][identity_index]["properties"]  }

            describe "NYU Shibboleth identity properties" do
              let(:bor_id) { ENV["TEST_ALEPH_USER"] || 'BOR_ID' }
              subject { response_properties[property] }

              context "when property is the NetID" do
                let(:property) { "uid" }
                it { should eql "js123" }
              end

              context "when property is the N Number" do
                let(:property) { "nyuidn" }
                it { should eql bor_id }
              end

              context "when property is the Given Name" do
                let(:property) { "first_name" }
                it { should eql "Jon" }
              end

              context "when property is the SurName" do
                let(:property) { "last_name" }
                it { should eql "Snow" }
              end

              context "when the property is the extra attributes" do
                let(:property) { "extra" }
                its(["entitlement"]) { should eql "nothing" }
              end

            end

            describe "Aleph identity properties" do
              let(:bor_id) { ENV["TEST_ALEPH_USER"] || 'BOR_ID' }
              let(:identity) { "aleph" }
              subject { response_properties[property] }

              context "when property is identifier" do
                let(:property) { "identifier" }
                it { should eql bor_id }
              end

              context "when property is PLIF status" do
                let(:property) { "plif_status" }
                it { should be_blank }
              end

              context "when property is ILL permission" do
                let(:property) { "ill_permission" }
                it { should eql "Y" }
              end

              context "when property is status" do
                let(:property) { "status" }
                it { should eql "NYU Undergraduate Student" }
              end

              context "when property is type" do
                let(:property) { "type" }
                it { should be_blank }
              end

            end

          end

          context "and the user's identity provider is New School LDAP" do
            let(:provider) { "new_school_ldap" }
            let(:bor_id) { ENV["TEST_ALEPH_USER"] || 'BOR_ID' }
            it { should have_json_path("identities/#{identity_index}/properties/uid") }
            it { should have_json_path("identities/#{identity_index}/properties/nyuidn") }
            it { should have_json_path("identities/#{identity_index}/properties/first_name") }
            it { should have_json_path("identities/#{identity_index}/properties/last_name") }
            describe "identity properties" do
              let(:response_properties) { JSON.parse(response.body)["identities"][identity_index]["properties"]  }
              subject { response_properties[property] }
              context "when property is the NetID" do
                let(:property) { "uid" }
                it { should eql "snowj" }
              end
              context "when property is the N Number" do
                let(:property) { "nyuidn" }
                it { should eql bor_id }
              end
              context "when property is the Given Name" do
                let(:property) { "first_name" }
                it { should eql "Jon" }
              end
              context "when property is the SurName" do
                let(:property) { "last_name" }
                it { should eql "Snow" }
              end
            end
            context "and the user's identity provider is Twitter", pending_implementation: true do
            end
            context "and the user's identity provider is Facebook", pending_implementation: true do
            end
          end
        end
      end
    end
  end
end
