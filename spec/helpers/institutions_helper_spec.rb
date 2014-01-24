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
describe InstitutionsHelper do
  describe '#current_institution' do
    context 'when the request is from off campus' do
      it 'should be the NYU institution' do
        expect(current_institute.code).to eql(:NYU)
        expect(current_institution.code).to eql(:NYU)
        expect(current_primary_institution.code).to eql(:NYU)
      end
    end

    context 'when the request is from on the New School campus' do
      it 'should be the New School institution' do
        allow(self).to receive(:primary_institution_from_ip).and_return(Institutions.institutions[:NS])
        expect(current_institute.code).to eql(:NS)
        expect(current_institution.code).to eql(:NS)
        expect(current_primary_institution.code).to eql(:NS)
      end
    end

    context 'when the request is by a NYSID user' do
      it "shoudl be the NYSID institution"
    end

    context 'when the request specifies the Cooper Union insitute' do
      it 'should be the Cooper Union institution' do
        allow(self).to receive(:institution_param).and_return(:CU)
        expect(current_institute.code).to eql(:CU)
        expect(current_institution.code).to eql(:CU)
        expect(current_primary_institution.code).to eql(:CU)
      end
    end
  end

  describe '#url_for' do
     context 'when the request specifies the New School institute' do
      it 'should have the institute=NS in the URL' do
        allow(self).to receive(:institution_param).and_return(:NS)
        expect(url_for({ controller: :users, action: :show })).to eql("/users/show?institute=NS")
      end
    end

    context 'when the request specifies the Cooper Union institute' do
      it 'should have the institute=CU in the URL' do
        allow(self).to receive(:institution_param).and_return(:CU)
        expect(url_for({ controller: :users, action: :show })).to eql("/users/show?institute=CU")
      end
    end
  end
end
