require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the InstitutionsHelper. For example:
#
# describe InstitutionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe Nyulibraries::Assets::InstitutionsHelper do

  include Nyulibraries::Assets::InstitutionsHelper

  describe '#current_institution' do
    subject(:institute) { current_institution }
    it { should be_a(Institutions::Institution) }

    describe '#code' do
      subject { institute.code }
      it { should_not be_nil }

      context 'when the request is from off all campuses' do
        it { should eql(:NYU) }
      end

      context 'when the request is from on the New School campus' do
        let(:ns_institution) { Institutions.institutions[:NS] }
        before do
          allow(self).to receive(:institution_from_ip).and_return(ns_institution)
        end
        it { should eql(:NS) }
      end

      context 'when the request is by a NYSID user' do
        let(:nysid_user) { build(:user, institution_code: 'NYSID')}
        before do
          @current_user = nysid_user
          allow(self).to receive(:current_user).and_return(nysid_user)
        end
        it { should eql(:NYSID) }
      end

      context 'when the request specifies the Cooper Union insitute' do
        before do
          allow(self).to receive(:institution_param).and_return(:CU)
        end
        it { should eql(:CU) }
      end

      context 'when the request specifies an invalid insitute' do
        before do
          allow(self).to receive(:institution_param).and_return(:INVALID)
        end
        it { should eql(:NYU) }
      end
    end
  end

  describe '#url_for' do
    subject { url_for({ controller: :users, action: :show, provider: "aleph", id: "username" }) }
    it { should_not be_nil }
    it { should be_a(String) }
    it { should_not be_empty }

    context 'when the request doesn\'t specify institute' do
      it { should eql("/users/aleph/username") }
    end

    context 'when the request specifies the New School institute' do
      before { allow(self).to receive(:institution_param).and_return(:ns) }
      it { should eql("/users/aleph/username/ns") }
    end
  end
end
