require 'spec_helper'
module Login
  module Aleph
    describe PatronLoader::BorInfoStrategy, vcr: { cassette_name: "aleph bor info" } do
      let(:identifier) { 'BOR_ID' }
      subject(:bor_info_strategy) { PatronLoader::BorInfoStrategy.new(identifier) }
      it { should be_a PatronLoader::Strategy }
      it { should be_a PatronLoader::BorInfoStrategy }
      describe '#identifier' do
        subject { bor_info_strategy.identifier }
        it { should eq identifier }
      end
      describe '#patron' do
        subject { bor_info_strategy.patron }
        context "when identifier is valid and returns a BorInfo object" do
          its(:identifier) { should eql "BOR_ID" }
          its(:plif_status) { should eql "PLIF LOADED" }
          its(:status) { should eql "NYU Administrator" }
          its(:type) { should eql "CB" }
          its(:ill_permission) { should eql "Y" }
        end
        context "when identifier is invalid" do
          let(:identifier) { 'INVALID_ID' }
          it { should be_nil }
        end
      end
    end
  end
end
