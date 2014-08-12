require 'spec_helper'
module Login
  module Aleph
    describe PatronLoader::BorInfoStrategy do
      let(:identifier) { 'N19064851' }
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
          its(:identifier) { should eql "N19064851" }
          its(:plif_status) { should be_nil }
          its(:status) { should eql "NYU Undergraduate Student" }
          its(:type) { should be_nil }
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
