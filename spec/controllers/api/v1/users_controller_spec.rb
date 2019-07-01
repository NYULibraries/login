require 'rails_helper'

describe Api::V1::UsersController do

  let(:identity) { provider }

  describe 'GET #show' do

    context "when the request doesn't have an access token" do

      context 'and not logged in' do
        before { get :show }
        subject { response }
        it { should_not be_successful }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

      context 'and logged in' do
        login_user
        before { get :show }
        subject { response }
        it { should_not be_successful }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

    end

    context "when the request has an access token" do

      context "and it's expired" do
        set_expired_access_token
        before { get :show, format: :json, params: { access_token: expired_access_token } }
        subject { response }
        it { should_not be_successful }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

      context "and it has been revoked" do
        set_revoked_access_token
        before { get :show, format: :json, params: { access_token: revoked_access_token } }
        subject { response }
        it { should_not be_successful }
        it("should be unauthorized") { expect(subject.message).to eq("Unauthorized") }
        it("should have a 401 status") { expect(subject.status).to be(401) }
      end

      context "and it's valid" do
        set_access_token
        before { get :show, format: :json, params: { access_token: access_token } }
        subject { response }

        it { should be_successful }

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
            it { should have_json_path("identities/#{index}/properties/plif_status") }
            it { should have_json_path("identities/#{index}/properties/patron_type") }
            it { should have_json_path("identities/#{index}/properties/patron_status") }
            it { should have_json_path("identities/#{index}/properties/ill_permission") }
            it { should have_json_path("identities/#{index}/properties/first_name") }
            it { should have_json_path("identities/#{index}/properties/last_name") }
            describe "identity properties" do
              let(:response_properties) { parse_json(body)["identities"][index]["properties"]  }
              subject { response_properties[property] }
              context "when property is the Aleph ID" do
                let(:property) { "uid" }
                it { should eql (ENV["TEST_ALEPH_USER"] || 'BOR_ID') }
              end
              context "when the property is the institution_code attributes" do
                let(:property) { "institution_code" }
                it { should eql "NYU" }
              end
              context "when the property is PLIF status" do
                let(:property) { "plif_status" }
                it { should eql "PLIF LOADED" }
              end
              context "when the property is patron status" do
                let(:property) { "patron_status" }
                it { should eql "60" }
              end
              context "when the property is patron type" do
                let(:property) { "patron_type" }
                it { should eql '' }
              end
              context "when the property is ILL permission" do
                let(:property) { "ill_permission" }
                it { should eql "Y" }
              end
              context "when the property is first name" do
                let(:property) { "first_name" }
                it { should eql "Triple" }
              end
              context "when the property is last name" do
                let(:property) { "last_name" }
                it { should eql "Tester" }
              end
            end
          end

          context "and the user's identity provider is NYU Shibboleth" do
            let(:provider) { "nyu_shibboleth" }

            it { should have_json_path("identities/#{identity_index}/properties/uid") }
            it { should have_json_path("identities/#{identity_index}/properties/nyuidn") }
            it { should have_json_path("identities/#{identity_index}/properties/first_name") }
            it { should have_json_path("identities/#{identity_index}/properties/last_name") }
            it { should have_json_path("identities/#{identity_index}/properties/entitlement") }

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

              context "when the property is the institution_code attributes" do
                let(:property) { "institution_code" }
                it { should eql "NYU" }
              end

              context "when the property is entitlement" do
                let(:property) { "entitlement" }
                it { should eql "nothing" }
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
                it { should eql "PLIF LOADED" }
              end

              context "when property is ILL permission" do
                let(:property) { "ill_permission" }
                it { should eql "Y" }
              end

              context "when property is patron status" do
                let(:property) { "patron_status" }
                it { should eql "60" }
              end

              context "when the property is the institution_code attributes" do
                let(:property) { "institution_code" }
                it { should eql "NYU" }
              end

              context "when property is patron type" do
                let(:property) { "patron_type" }
                it { should eql "" }
              end

              context "when property is first_name" do
                let(:property) { "first_name" }
                it { should eql "Triple" }
              end

              context "when property is last_name" do
                let(:property) { "last_name" }
                it { should eql "Tester" }
              end

              context "when property is address" do
                let(:property) { "address" }
                it { should eql("city"=>"NEW YORK", "postal_code"=>"12345", "state"=>"NY", "street_address"=>"123 Main St") }
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
            let(:response_properties) { JSON.parse(response.body)["identities"][identity_index]["properties"]  }
            describe "New School identity properties" do
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
              context "when the property is the institution_code attributes" do
                let(:property) { "institution_code" }
                it { should eql "NS" }
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
                it { should eql "PLIF LOADED" }
              end
              context "when property is ILL permission" do
                let(:property) { "ill_permission" }
                it { should eql "Y" }
              end
              context "when property is status" do
                let(:property) { "patron_status" }
                it { should eql "60" }
              end
              context "when the property is the institution_code attributes" do
                let(:property) { "institution_code" }
                it { should eql "NYU" }
              end
              context "when property is type" do
                let(:property) { "patron_type" }
                it { should eql "" }
              end
              context "when property is first_name" do
                let(:property) { "first_name" }
                it { should eql "Triple" }
              end
              context "when property is last_name" do
                let(:property) { "last_name" }
                it { should eql "Tester" }
              end
            end
          end

          context "and the user's identity provider is Twitter" do
            let(:provider) { "twitter" }

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
                it { should eql "" }
              end
              context "when property is the Given Name" do
                let(:property) { "first_name" }
                it { should eql "Jon" }
              end
              context "when property is the SurName" do
                let(:property) { "last_name" }
                it { should eql "Snow" }
              end
              context "when property is the NickName" do
                let(:property) { "nickname" }
                it { should eql "@knowsnothing" }
              end
              context "when property is the name" do
                let(:property) { "name" }
                it { should eql "Jon Snow" }
              end
              context "when property is the location" do
                let(:property) { "location" }
                it { should eql "The Wall" }
              end

              context "when the property is the institution_code attributes" do
                let(:property) { "institution_code" }
                it { should be_blank }
              end
            end
          end

        end
      end
    end
  end
end
