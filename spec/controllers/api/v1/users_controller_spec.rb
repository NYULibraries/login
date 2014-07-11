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

          subject(:body) { response.body }

          context "and the user's identity provider is Aleph" do
            let(:provider) { "aleph" }
            let(:index)    { parse_json(body)["identities"].find_index {|x| x["provider"].eql? provider} }

            it { should have_json_path("identities/#{index}/properties/uid") }
            it { should have_json_path("identities/#{index}/properties/extra/raw_info/bor_auth/z303/z303_birthplace") }
            it { should have_json_path("identities/#{index}/properties/extra/raw_info/bor_auth/z305/z305_bor_type") }
            it { should have_json_path("identities/#{index}/properties/extra/raw_info/bor_auth/z305/z305_bor_status") }
            it { should have_json_path("identities/#{index}/properties/extra/raw_info/bor_auth/z305/z305_photo_permission") }

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

          context "and the user's identity provider is Twitter" do

          end

          context "and the user's identity provider is Facebook" do

          end

          context "and the user's identity provider is NYU Shibboleth" do
            let(:provider) { "nyu_shibboleth" }
            let(:index)    { parse_json(subject)["identities"].find_index {|x| x["provider"].eql? provider} }

            it { should have_json_path("identities/#{index}/properties/uid") }
            it { should have_json_path("identities/#{index}/properties/nyuidn") }
            it { should have_json_path("identities/#{index}/properties/first_name") }
            it { should have_json_path("identities/#{index}/properties/last_name") }
            it { should have_json_path("identities/#{index}/properties/extra/entitlement") }

            describe "identity properties" do
              let(:response_properties) { JSON.parse(response.body)["identities"].first["properties"]  }
              subject { response_properties[property] }

              context "when property is the NetID" do
                let(:property) { "uid" }
                it { should eql "js123" }
              end

              context "when property is the N Number" do
                let(:property) { "nyuidn" }
                it { should eql "js123" }
              end

              context "when property is the Given Name" do
                let(:property) { "first_name" }
                it { should eql "Jon" }
              end

              context "when property is the SurName" do
                let(:property) { "last_name" }
                it { should eql "Snow" }
              end

              context "when property is the Entitlement" do
                let(:property) { "extra" }

                it { should include("entitlement" => "nothing") }
              end
            end
          end

          context "and the user's identity provider is New School LDAP" do
            let(:provider) { "new_school_ldap" }
            let(:index)    { parse_json(subject)["identities"].find_index {|x| x["provider"].eql? provider} }

            it { should have_json_path("identities/#{index}/properties/uid") }
            it { should have_json_path("identities/#{index}/properties/nyuidn") }
            it { should have_json_path("identities/#{index}/properties/first_name") }
            it { should have_json_path("identities/#{index}/properties/last_name") }

            describe "identity properties" do
              let(:response_properties) { JSON.parse(response.body)["identities"].first["properties"]  }
              subject { response_properties[property] }

              context "when property is the NetID" do
                let(:property) { "uid" }
                it { should eql "snowj" }
              end

              context "when property is the N Number" do
                let(:property) { "nyuidn" }
                it { should eql "N00000000" }
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

          end

        end

      end

    end

  end

end
